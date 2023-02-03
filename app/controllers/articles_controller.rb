class ArticlesController < ApplicationController

  before_action :set_one_month, only: [:create]
  before_action :correct_article_user_or_admin, only: [:destroy]
  before_action :correct_article_user, only: [:edit, :update]

  def search
    @user = User.find(params[:user_id])
# グラフの年月を絞り込む時に、すでに表示されていた投稿一覧がある場合に、params[:articles]でビューから配列で受け取り、すでに表示されていた投稿一覧を抽出する
    if params[:articles]
      @articles = []
      params[:articles].each do |article|
        new_article = Article.find_by(id: article[:id])
        @articles.push(new_article)
      end
# グラフの年月絞り込みではなく、キーワード検索、日付けでの絞り込み検索の場合の投稿一覧取得
    else
      @articles = Article.where(user_id: @user.id)
    end
    @comment = Comment.new

# グラフの年月を絞り込む
    if params[:"year_month(1i)"]
      year = params[:"year_month(1i)"]
      month = params[:"year_month(2i)"]
      day = params[:"year_month(3i)"]

      # month,dayが１桁の場合、数字の前に0を付ける
      if count_digits(month) == 1
        month = "0#{month}"
      end
      if count_digits(day) == 1
        day = "0#{day}"
      end
      first_day = "#{year}-#{month}-#{day}"
      @description_first_day = first_day

      @first_day = "#{year}年 #{month}月"
      @articles_graph = Article.where(user_id: @user.id)
      @articles_30days = @articles_graph.where(date: first_day.in_time_zone.all_month).order(date: "ASC")
      # コントローラーの下部でメソッドを定義
      @articles_30days_date = articles_30days_date(@articles_30days)

      render "index"

# キーワード検索、日付での絞り込み検索
    else
      @first_day = params[:first_day] if params[:first_day]

      # キーワードがある場合
      if params[:keyword] != ""
        # 日付けでの絞り込み検索がある場合
        if params[:date_from] != "" || params[:date_to] != ""
          @articles = @articles.user_articles_search(params[:date_from], params[:date_to])
        end
        @articles = @articles.search(params[:keyword]).order(date: "DESC")
      # キーワードがなく、日付けでの絞り込み検索がある場合
      elsif params[:date_from] != "" || params[:date_to] != ""
        @articles = @articles.user_articles_search(params[:date_from], params[:date_to]).order(date: "DESC")
      end
# キーワード検索、日付での絞り込み検索の時に、すでに表示されていたグラフがある場合、params[:articles_30days]を渡し表示する
      if params[:articles_30days]
        @articles_30days = []
        params[:articles_30days].each do |article|
          new_article = Article.find_by(id: article[:id])
          @articles_30days.push(new_article)
        end
      else
# キーワード検索、日付での絞り込み検索の時に、すでに表示されていたグラフがない場合、グラフ表示のための変数を定義
        @month = Date.today
        @articles_30days = Article.where(date: @month.in_time_zone.all_month).order(date: "ASC")
      end
      @articles_30days_date = articles_30days_date(@articles_30days)
      render "index"
    end
  end


  def index
    @user = User.find(params[:user_id])
    @articles = Article.where(user_id: params[:user_id])
    @comment = Comment.new
    @month = Date.today
    @articles_30days = Article.where(date: @month.in_time_zone.all_month).order(date: "ASC")

    @articles_30days_date = articles_30days_date(@articles_30days)
# indexアクションを叩いた時、グラフが表示されない。更新ボタンを押せば表示される
    # render "index"
  end


  def new
    # sessions_helperのcurrent_userを叩く
    if current_user
      @user = current_user
      @article = Article.new
    else
      flash[:danger] = '投稿するにはログインしてください。'
      redirect_to root_path
    end
  end

  def create
    @article = Article.new(article_params)
    if Article.where(user_id: @article.user.id, date: @article.date) != []
      flash.now[:danger] = "同じ計測日の投稿はできません。"
      @user = current_user
      return render :new
    end
    if @article.save
      flash[:success] = '新規投稿しました。' # フラッシュメッセージを渡す
      redirect_to user_article_path(user_id:@article.user_id, id:@article.id)
    else
      @user = current_user
      render :new
    end
  end


  def show
    @article = Article.find(params[:id])
    # firstがないと配列になってしまうため、エラーとなりweightのデータがとれなくなる
    @article_one_month_ago = Article.where(user_id: @article.user.id, date: (@article.date - 1.month)).first
    @comment = Comment.new
  end


  def edit
    @article = Article.find_by(params[:user_id], params[:id])
  end


  def update
    # createとは異なり、find文が必要
    @article = Article.find(params[:id])
    @article.update_attributes(article_params)
    if @article.save
      flash[:success] = "投稿を更新しました"
      redirect_to user_article_path(user_id:@article.user_id, id:@article.id)
    else
      render :edit
    end
  end


  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      flash[:success] = "#{@article.date}のデータを削除しました。"
      redirect_to root_path
    else
      flash[:danger] = "#{@article.date}のデータ削除に失敗しました。"
      redirect_to root_path
    end
  end

  def articles_30days_date(articles_30days)
    @articles_30days_date = []
    @articles_30days_weight = []
    @articles_30days_body_fat_percentage = []
    articles_30days.each do |article|
        @articles_30days_date << article.date
        @articles_30days_weight << article.weight
        @articles_30days_body_fat_percentage << article.body_fat_percentage
    end
# コントローラーからビューへ配列を渡すために、「.to_json.html_safe」を使う
    @articles_30days_date_j = @articles_30days_date.to_json.html_safe
    @articles_30days_weight_j = @articles_30days_weight.to_json.html_safe
    @articles_30days_body_fat_percentage_j = @articles_30days_body_fat_percentage.to_json.html_safe

    @max_weight = @articles_30days_weight.max
    @min_weight = @articles_30days_weight.min
    @max_body_fat_percentage = @articles_30days_body_fat_percentage.max
    @min_body_fat_percentage = @articles_30days_body_fat_percentage.min
  end
end

  private

  # ストロングパラメーター 入力できるカラムを制御
  def article_params
    # mergeでuser.idを入力
    params.require(:article).permit(:date, :weight, :body_fat_percentage, :meal_morning, :meal_lunch,
      :meal_dinner, :meal_snack, :exercise, :memo).merge(user_id: current_user.id)
  end

  def count_digits(num)
    num.to_s.length
  end


    # if params[:keyword] != "" || (params[:date_from] != "" || params[:date_to] != "")


          # if params[:"year_month(2i)"] == 1
        #   month = Jan
        # end
        # @articles_30days = @articles.where("date LIKE?": params[:"year_month(1i)"], date: month]).order(date: "ASC")
        # @articles_30days = @articles.where("date LIKE?": '%#{params[:"year_month(1i)"]}%', "date LIKE?": month).order(date: "ASC")



    # @articles_30days = []
    # today_date = Date.today
    # 30.times.each do |i|
    #   # 30日前からの昇順にするための書き方
    #   article = @articles.find_by(date: today_date - 30 + i)
    #   if article.nil?
    #   # weight: '', body_fat_percentage: ''を加える
    #     article = Article.create(date: today_date - 30 + i, weight: '', body_fat_percentage: '' )

    #   end
    #   @articles_30days << article
    # end


      # @articles_30days_date = []
      # @articles_30days_weight = []
      # @articles_30days_body_fat_percentage = []
      # @articles_30days.each do |article|
      #   @articles_30days_date << article.date
      #   @articles_30days_weight << article.weight
      #   @articles_30days_body_fat_percentage << article.body_fat_percentage
      # end
      # @articles_30days_date_j = @articles_30days_date.to_json.html_safe
      # @articles_30days_weight_j = @articles_30days_weight.to_json.html_safe
      # @articles_30days_body_fat_percentage_j = @articles_30days_body_fat_percentage.to_json.html_safe

      # @max_weight = @articles_30days_weight.max
      # @min_weight = @articles_30days_weight.min
      # @max_body_fat_percentage = @articles_30days_body_fat_percentage.max
      # @min_body_fat_percentage = @articles_30days_body_fat_percentage.min

    # 取得した時刻が含まれる月の範囲のデータを取得
    # if @articles_30days == nil
    #   # @articles_30days = @articles.where(date: @month.all_month).order(date: "ASC")
    #   # @articles_30days = Article.where(date: @month.in_time_zone.all_month).order(date: "ASC")
    #   # @month = Date.today
    #   @articles_30days = Article.where(date: @month.in_time_zone.all_month).order(date: "ASC")
    # end
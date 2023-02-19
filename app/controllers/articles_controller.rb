class ArticlesController < ApplicationController

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
      @articles = Article.where(user_id: @user.id).where.not(weight: nil)
    end
    @comment = Comment.new

# (1)グラフの年月を絞り込む場合
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
      @articles_one_month = @articles_graph.where(date: first_day.in_time_zone.all_month).order(date: "ASC")
      # コントローラーの下部でメソッドを定義
      @articles_one_month_date = articles_one_month_date(@articles_one_month)

      # 検索国の絞り込みのインスタンス変数を渡す html側ではそれぞれparams[:keyword]などで受け取れる
      if params[:keyword]
        @keyword = params[:keyword]
      end
      if params[:date_from]
        @date_from = params[:date_from]
      end
      if params[:date_to]
        @date_to = params[:date_to]
      end

      render "index"

# (2)キーワード検索、日付での絞り込み検索の場合
    else
      if params[:first_day]
        @first_day = params[:first_day]
      end

      # キーワードがある場合
      if params[:keyword] != ""
        # 日付けでの絞り込み検索がある場合
        if params[:date_from] != "" || params[:date_to] != ""
          @articles = @articles.user_articles_search(params[:date_from], params[:date_to]).where.not(weight: nil)
        end
        @articles = @articles.search(params[:keyword]).order(date: "DESC").where.not(weight: nil)
      # キーワードがなく、日付けでの絞り込み検索がある場合
      elsif params[:date_from] != "" || params[:date_to] != ""
        @articles = @articles.user_articles_search(params[:date_from], params[:date_to]).order(date: "DESC").where.not(weight: nil)
      end
# 「グラフデータがありません」の場合、先にこちらを読み込ませる
      if params[:articles_one_month_date]
        @month = Date.today
        @articles_one_month = Article.where(user_id: @user.id, date: @month.in_time_zone.all_month).order(date: "ASC")
# すでに表示されていたグラフがある場合、params[:articles_one_month]を渡し表示する
      elsif params[:articles_one_month]
        @articles_one_month = []
        params[:articles_one_month].each do |article|
          new_article = Article.find(article[:id])
            # new_article = Article.find_by(user_id: @user.id, id: article.user_id)
          @articles_one_month.push(new_article)
        end
      else
# すでに表示されていたグラフがない場合、グラフ表示のための変数を定義
        @month = Date.today
        @articles_one_month = Article.where(user_id: @user.id, date: @month.in_time_zone.all_month).order(date: "ASC")
      end
      @articles_one_month_date = articles_one_month_date(@articles_one_month)

      # 年月絞り込みのインスタンス変数を渡す html側ではparams[:description_first_day]で受け取れる
      if params[:description_first_day]
        @description_first_day = params[:description_first_day]
      end

      render "index"
    end
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
    @user = current_user
    if params[:article][:date].empty? || params[:article][:weight].empty? || params[:article][:body_fat_percentage].empty?
      flash.now[:danger] = "計測日、体重、体脂肪率は入力必須項目です"
      @article = Article.new(article_params)
      return render :new
    end

    @first_day = params[:article][:date].to_date.beginning_of_month
    check_articles_month = Article.where(user_id: params[:user_id], date: @first_day)
    # check_articles_monthが存在しない場合、その月の1ヶ月分のデータを作成
    unless check_articles_month.present?
      set_one_month
    end
    check_same_day_article = Article.find_by(user_id: params[:user_id], date: params[:article][:date])

    if check_same_day_article.weight != nil
      @article = Article.new(article_params)
      flash.now[:danger] = "同じ計測日の投稿はできません。該当日付の記事を編集、保存してください、"
      return render :new
    end

    @article = Article.find_by(user_id:@user.id, date: params[:article][:date])

# seedデータと矛盾するので一旦グレーアウト → 本番環境ではグレーアウト解除
    if @article != nil
      if @article.date >= Date.tomorrow
        @article = Article.new(article_params)
        flash.now[:danger] = "未来日付の投稿はできません。"
        @user = current_user
        return render :new
      end
    else
      @article = Article.new(article_params)
      flash.now[:danger] = "データが間違っています。月末までのデータが作成されておりません。"
      @user = current_user
      return render :new
    end

    @article.update_attributes(article_params)

    if @article.save
      flash[:success] = "投稿を更新しました"
      redirect_to user_article_path(user_id: @article.user_id, id: @article.id)
    else
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
    # @article = Article.find_by(params[:user_id], params[:id])と記述していて更新すると自分以外の投稿になってエラー
    @article = Article.find_by(user_id: params[:user_id], id: params[:id])
  end


  def update
    @article = Article.find(params[:id])
    @user = current_user

    if params[:article][:date].empty? || params[:article][:weight].empty? || params[:article][:body_fat_percentage].empty?
      flash.now[:danger] = "計測日、体重、体脂肪率は入力必須項目です"
      @article = Article.new(article_params)

      return render :edit
    end

# seedデータと矛盾するので一旦グレーアウト → 本番環境ではグレーアウト解除
    if @article.date >= Date.tomorrow
      @article = Article.new(article_params)
      flash.now[:danger] = "未来日付の投稿はできません。"
      @user = current_user
      return render :edit
    end

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


  def index
    @user = User.find(params[:user_id])
    @articles = Article.where(user_id: params[:user_id]).where.not(weight: nil)
    @comment = Comment.new
    @month = Date.today
# user_id: @user.idの指定が漏れていたのでグラフが複数の違う人たちのデータを引っ張ってしまった
    @articles_one_month = Article.where(user_id: @user.id, date: @month.in_time_zone.all_month).order(date: "ASC")
    @articles_one_month_date = articles_one_month_date(@articles_one_month)
# indexアクションを叩いた時、グラフが表示されない。更新ボタンを押せば表示される
    # render "index"
  end


  def articles_one_month_date(articles_one_month)
    @articles_one_month_date = []
    @articles_one_month_weight = []
    @articles_one_month_body_fat_percentage = []
    articles_one_month.each do |article|
        @articles_one_month_date << article.date
        @articles_one_month_weight << article.weight
        @articles_one_month_body_fat_percentage << article.body_fat_percentage
    end

# コントローラーからビューへ配列を渡すために、「.to_json.html_safe」を使う
    @articles_one_month_date_j = @articles_one_month_date.to_json.html_safe
    @articles_one_month_weight_j = @articles_one_month_weight.to_json.html_safe
    @articles_one_month_body_fat_percentage_j = @articles_one_month_body_fat_percentage.to_json.html_safe

    @max_weight = @articles_one_month_weight.compact.max
    @min_weight = @articles_one_month_weight.compact.min
    @max_body_fat_percentage = @articles_one_month_body_fat_percentage.compact.max
    @min_body_fat_percentage = @articles_one_month_body_fat_percentage.compact.min
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

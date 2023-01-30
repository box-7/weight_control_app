class ArticlesController < ApplicationController

  before_action :correct_article_user_or_admin, only: [:destroy]
  before_action :correct_article_user, only: [:edit, :update]


  def search
    @user = User.find(params[:user_id])
    @articles = Article.where(user_id: @user.id)

    if params[:keyword] != ""
      if params[:date_from] != "" || params[:date_to] != ""
        @articles = @articles.user_articles_search(params[:date_from], params[:date_to])
      end
      @articles = @articles.search(params[:keyword])
    elsif params[:date_from] != "" || params[:date_to] != ""
      if params[:keyword] != ""
        @articles = @articles.search(params[:keyword])
      end
      @articles = @articles.user_articles_search(params[:date_from], params[:date_to])
    end
    @articles = @articles.order(date: "DESC")
    render "index"
  end







  def index
    @user = User.find(params[:user_id])
    # @articles = Article.where(user_id: params[:user_id]).order(date: "DESC")
    @articles = Article.where(user_id: params[:user_id])
    @comment = Comment.new

    @articles_30days = []
    today_date = Date.today
    30.times.each do |i|
      # 30日前からの昇順にするための書き方
      article = @articles.find_by(date: today_date - 30 + i)
      if article.nil?
# weight: 0, body_fat_percentage: 0 を変える
        article = Article.create(date: today_date - 30 + i, weight: '', body_fat_percentage: '' )
        # article = Article.new
        # binding.pry
        # artilce[:date] = today_date - (1+i)
        # artilce.weight = ''
        # artilce.body_fat_percentage = ''
      end
      @articles_30days << article
    end
    # @articles_30days = @articles_30days.order(date: "DESC")


    @articles_30days_date = []
    @articles_30days_weight = []
    @articles_30days_body_fat_percentage = []
    @articles_30days.each do |article|
      @articles_30days_date << article.date
      @articles_30days_weight << article.weight
      @articles_30days_body_fat_percentage << article.body_fat_percentage
    end
    @articles_30days_date_j = @articles_30days_date
    @articles_30days_weight_j = @articles_30days_weight
    @articles_30days_body_fat_percentage_j = @articles_30days_body_fat_percentage



    # @articles_30days_date_j = @articles_30days_date.to_json.html_safe → ArrayがActiveSupport::SafeBufferに変わる
    # @articles_30days_date_j = @articles_30days_date.to_json.html_safe
    # @articles_30days_weight_j = @articles_30days_weight.to_json.html_safe
    # @articles_30days_body_fat_percentage_j = @articles_30days_body_fat_percentage.to_json.html_safe
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
end

  # ストロングパラメーター 入力できるカラムを制御
  def article_params
    # mergeでuser.idを入力
    params.require(:article).permit(:date, :weight, :body_fat_percentage, :meal_morning, :meal_lunch,
      :meal_dinner, :meal_snack, :exercise, :memo).merge(user_id: current_user.id)
  end


  # def search
  #   # keyword,date_from,date_to何も入力されていないとき
  #   if params[:keyword] == "" && params[:date_from] == "" && params[:date_to] == ""
  #     @user = User.find(params[:user_id])
  #     @articles = Article.where(user_id: params[:user_id]).order(date: "DESC")
  #     render "index"
  #     return
  #   end
  #   # form_withからparams[:user_id]を渡す
  #   @user = User.find(params[:user_id])

  #   # article.rbのsearchメソッドを叩く whereをつなげられる
  #   @articles = Article.search(params[:keyword]).where(user_id: @user.id)

  #   # 日付入力がある場合のみ、article.rbのsuser_articles_searchメソッドを叩く
  #   unless params[:date_from] == "" && params[:date_to] == ""
  #     @articles = @articles.user_articles_search(params[:date_from], params[:date_to])
  #   end

  #   # 検索窓での表示で使う
  #   @keyword = params[:keyword]
  #   @date_from = params[:date_from]
  #   @date_to = params[:date_to]
  #   # articlesのindex
  #   render "index"
  # end
class ArticlesController < ApplicationController

  before_action :correct_article_user, only: [:edit, :update, :destroy]

  def index
    @user = User.find(params[:id])
    @articles = Article.where(user_id: params[:id]).order(date: "DESC")
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
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = '新規投稿しました。' # フラッシュメッセージを渡す
      redirect_to @article
    else
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
    # firstがないと配列になってしまうため、エラーとなりweightのデータがとれなくなる
    @article_one_month_ago = Article.where(user_id: @article.user.id, date: (@article.date - 1.month)).first
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    # createとは異なり、find文が必要
    @article = Article.find(params[:id])
    @article.update_attributes(article_params)
    if @article.save
      flash[:success] = "投稿を更新しました"
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:success] = "#{@article.date}のデータを削除しました。"
    redirect_to root_path
  end
end

  # ストロングパラメーター 入力できるカラムを制御
  def article_params
    # mergeでuser.idを入力
    params.require(:article).permit(:date, :weight, :body_fat_percentage, :meal_morning, :meal_lunch,
      :meal_dinner, :meal_snack, :exercise, :memo).merge(user_id: @user.id)
  end

class ApplicationController < ActionController::Base
  # CSRF対策(クロスサイトリクエストフォージェリ)
  protect_from_forgery with: :exception
  # session_helperを読み込む
  include SessionsHelper

  # 該当月最初の投稿作成前に1ヶ月分の日付のみのデータをセット
  def set_one_month
    @first_day = params[:article][:date].to_date.beginning_of_month
    @last_day = @first_day.end_of_month
    user = User.find(params[:user_id])

      # one_monthを定義 対象の月の日にちを[*@first_day..@last_day]で配列化 
    one_month = [*@first_day..@last_day]

    one_month.each do |day|
      # user.articles.create!だとユーザーもたくさん作成されてしまう
      user.article.create!(
        user_id: user.id,
        date: day,
      # weight,body_fat_percentageはnilだとグラフがエラーになる
        weight:'',
        body_fat_percentage:'',
      )
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = '自分以外のユーザーは編集できません。'
      redirect_to(root_url)
    end
  end

  def correct_user_or_admin
    @user = User.find(params[:id])
    if current_user.admin?
      return
    elsif current_user?(@user)
      return
    else
      flash[:danger] = '自分以外のユーザーは編集できません。'
      redirect_to(root_url)
    end
  end

  def correct_article_user
    @article = Article.find(params[:id])
    @user = User.find_by(id: params[:user_id])
    unless current_user?(@user)
      flash[:danger] = '自分以外の投稿は編集できません。'
      redirect_to(root_url)
    end
  end

  def correct_article_user_or_admin
    @article = Article.find(params[:id])
    if current_user.admin?
      return
    elsif current_user.id == @article.user_id
      return
    else
      flash[:danger] = '自分以外の投稿は削除できません。'
      redirect_to(root_url)
    end
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = '管理者権限が必要です。'
      redirect_to root_url
    end
  end
end

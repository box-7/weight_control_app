class ApplicationController < ActionController::Base
  # CSRF対策(クロスサイトリクエストフォージェリ)
  protect_from_forgery with: :exception
  # session_helperを読み込む
  include SessionsHelper

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = '自分以外のユーザーは編集できません。'
      redirect_to(root_url)
    end
  end

  def correct_article_user
    @article = Article.find(params[:id])
    @user = User.find_by(id: @article.user.id)

    unless current_user?(@user)
      flash[:danger] = '自分以外の投稿は編集できません。'
      redirect_to(root_url)
    end
  end

end

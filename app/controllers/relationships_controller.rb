class RelationshipsController < ApplicationController

  def index
    user = User.find(current_user.id)
    @users = user.followings
  end

  # フォローするとき
  def create
    # user.rbのメソッドを呼び出す
    current_user.follow(params[:user_id])
    # 遷移する前のURL（HTTPリファラ）を取得し、リダイレクト
    redirect_to request.referer
  end

  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end



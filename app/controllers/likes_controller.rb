class LikesController < ApplicationController
    before_action :article_params

    binding.pry
    def create
        Like.create(user_id: current_user.id, article_id: params[:id])
        #「redirect_to」を記述すると画面遷移が行われてしまい、非同期処理ができなくなってしまうため削除
        # redirect_to user_article_path(user_id: current_user.id, article_id: params[:id])
    end
    def destroy
        Like.find_by(user_id: current_user.id, article_id: params[:id]).destroy
        # redirect_to user_article_path(user_id: current_user.id, article_id: params[:id])
    end

    private

    def article_params
        @article = Article.find(params[:id])
    end
end

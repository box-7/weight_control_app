class CommentsController < ApplicationController

    def create
        @article = Article.find(params[:article_id])
        @comment = Comment.new(comment_params)
        # @comment.user_id = current_user.id
        # @comment.article_id = @article.id
        if @comment.save
            flash[:success] = 'コメントを投稿しました'
            if params[:controller_path] == 'top_index'
                redirect_to root_path
            elsif params[:controller_path] == 'articles_index'
                redirect_to user_articles_path(user_id: @article.user_id)
            else
                redirect_to user_article_path(user_id: @article.user_id, id: @article.id)
            end
        else
# render部分がエラー
            if params[:controller_path] == 'top_index'
                @user = User.find(@article.user_id)
                @articles = Article.all.order(created_at: "DESC")
                # @articles = Article.where(user_id: @article.user_id).order(date: "DESC")
                # render template: "top/index"
                render "top/index"
                # render 'app/views/top/index.html.erb'
                # render partial: 'top/index', locals: { @user: User.find_by(id: article.user_id) }
            elsif params[:controller_path] == 'articles_index'
                render 'articles/index'
            else
                render 'articles/show'
                # redirect_to user_article_path(user_id: @article.user_id, id: @article.id)
            end
            # render :new
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id], article_id: params[:article_id], user_id: params[:user_id])
        @article = Article.find(@comment.article_id)
        @comment.destroy
        redirect_to user_article_path(user_id: @article.user_id, id: @article.id), alert: 'コメントを削除しました'
    end

    private

    def comment_params
        # permit(:comment)の箇所を、permit(params[:comment])と書いてしまってはまった
        params.require(:comment).permit(:comment).merge(user_id: current_user.id, article_id: @article.id)
    end

end

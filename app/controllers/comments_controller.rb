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
            if params[:controller_path] == 'top_index'
                flash[:danger] = 'コメントが空白か101文字以上のためコメントできません'
                @user = User.find(@article.user_id)
                @articles = Article.all.order(created_at: "DESC")
                render "top/index"
            elsif params[:controller_path] == 'articles_index'
                flash[:danger] = 'コメントが空白か101文字以上のためコメントできません'
                @user = User.find(params[:user_id])
                @articles = Article.where(user_id: params[:user_id]).order(date: "DESC")
                render 'articles/index'
            else
                # モデルのバリデーションエラーが表示されるのでflashは不要
                render 'articles/show'
            end
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id], article_id: params[:article_id], user_id: params[:user_id])
        @article = Article.find(@comment.article_id)
        if @comment.destroy
            flash[:success] = 'コメントを削除しました'
        else
            flash[:danger] = "コメント削除に失敗しました。"
        end
        if params[:controller_path] == 'top_index'
            redirect_to root_path
        elsif params[:controller_path] == 'articles_index'
            redirect_to user_articles_path(user_id: @article.user_id)
        else
            redirect_to user_article_path(user_id: @article.user_id, id: @article.id)
        end
    end

    private

    def comment_params
        # permit(:comment)の箇所を、permit(params[:comment])と書いてしまってはまった
        params.require(:comment).permit(:comment).merge(user_id: current_user.id, article_id: @article.id)
    end

end

class TopController < ApplicationController

    def search
        @articles = Article.search(params[:keyword])
        # 検索窓での表示で使う
        @keyword = params[:keyword]
        @comment = Comment.new
        # home（top)のindex
        render "top/index"
    end

    def index
        @articles = Article.all.where.not(weight: nil).order(created_at: "DESC")
        @comment = Comment.new
    end
end

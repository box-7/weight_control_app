class TopController < ApplicationController

    def search
        @articles = Article.search(params[:keyword])
        # 検索窓での表示で使う
        @keyword = params[:keyword]
        # home（top)のindex
        render "top/index"
    end

    def index
        @articles = Article.all.order(created_at: "DESC") 
    end
end

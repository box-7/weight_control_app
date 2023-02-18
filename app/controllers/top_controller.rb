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
        # 順序はcreated_atだと正しくならない(その月の最初のデータが作成されたときに1ヶ月分のデータが生成されるため)。updated_atにする
        @articles = Article.all.where.not(weight: nil).order(updated_at: "DESC")
        @comment = Comment.new
    end
end

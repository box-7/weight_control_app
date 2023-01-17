class TopController < ApplicationController
    def index
        @articles = Article.all.order(created_at: "DESC") 
    end
end

class TopController < ApplicationController
    def index
        @articles = Article.all
    end
end

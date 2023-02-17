module TopHelper
    def weight_loss(article)
        # グラフ生成のため月日の自動生成が走り、体重がnilのものも存在するため、.where.not(weight: nil)を指定する
        # (created_at: :DESC)だと直近のものになってしまうため、(created_at: :ASC)
        oldest_weight = Article.where(user_id: article.user_id).where.not(weight: nil).order(created_at: :ASC).first

        if article.weight && oldest_weight.weight
            weight_loss = article.weight - oldest_weight.weight
            return weight_loss.round(1)
        end
    end
end

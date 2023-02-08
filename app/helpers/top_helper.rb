module TopHelper
    def weight_loss(article)
        # グラフ生成のため月日の自動生成が走り、体重がnilのものも存在するため、.where.not(weight: nil)を指定する
        oldest_weight = Article.where(user_id: article.user_id).where.not(weight: nil).order(created_at: :DESC).first

        weight_loss = article.weight - oldest_weight.weight
        return weight_loss.round(1)
    end
end

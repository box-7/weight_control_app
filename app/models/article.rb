class Article < ApplicationRecord
    belongs_to :user
    has_many :likes
    has_many :comments, dependent: :destroy

    validates :date, presence: true
    # 1ヶ月ごとの日付データを作成する際にエラーになるためコメントアウト
    # validates :weight, presence: true
    # validates :body_fat_percentage, presence: true

    validates :meal_morning, length: { maximum: 50 }
    validates :meal_lunch, length: { maximum: 50 }
    validates :meal_dinner, length: { maximum: 50 }
    validates :meal_snack, length: { maximum: 50 }
    validates :exercise, length: { maximum: 50 }
    validates :memo, length: { maximum: 150 }

    def self.search(keyword)
        where(["meal_morning like? OR meal_lunch like? OR meal_dinner like? OR meal_snack like? OR exercise like? OR memo like?",
            "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
    end

    def self.user_articles_search(date_from, date_to)
        # scope :user_articles_search, -> (keyword, date_from, date_to) do
        # .where("date <= ?", date_to)の書き方、dateかdate_toかで迷った
        # 最初は小さく実装する「〜から〜まで」ではなく「〜まで」のみで実装する
        # もっとシンプルに書けそうだが、if文でやる方法以外うまくできなかった
            # where(["meal_morning like? OR meal_lunch like? OR meal_dinner like? OR meal_snack like? OR exercise like? OR memo like?","%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
            # .where("date >= ? AND date <= ? ", date_from, date_to)
        if date_from != "" && date_to != ""
            where(date: date_from..date_to)
        elsif date_from == "" && date_to != ""
            where("date <= ?", date_to)
        elsif date_from != "" && date_to == ""
            where("date >= ?", date_from)
        end
    end
end

        # where(["meal_morning like? OR meal_lunch like? OR meal_dinner like? OR meal_snack like? OR exercise like? OR memo like?",
        #     "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
        #     .where("date >= ?", date_from)

            # .where(“date BETWEEN ? AND ?”, date_from, date_to)
            # Pattern.where(“updated_at BETWEEN ? AND ?”, from, to)
            # ("date >= ?", date_from)
            # ("date <= ?", date_to))
            # self.where(created_at: date.today.beginning_of_week - 1..Time.now.end_of_week - 1).sum(:time)
            # .where(("? >= date", date_from)..("date <= ?", date_to))
            # .where(date: date_from..date_to)
            # .where(date: (? <= date_from)..(date_to <= ?))
            # .where(("? <= date_from", date_from)..("date_to <= ?", date_to))
            # .where(("? <= date_from", date_from)..("date_to <= ?", date_to))
            # Model.where("created_at <= ?", 日付)
        # end

    # scope :date_from, -> (from) { where('? <= date_from', from) if from.present? }
    # scope :date_to, -> (to) { where('date_to <= ?', to) if to.present? }




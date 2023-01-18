class Article < ApplicationRecord
    belongs_to :user

    validates :date, presence: true
    validates :weight, presence: true
    validates :body_fat_percentage, presence: true

    validates :meal_morning, length: { maximum: 50 }
    validates :meal_lunch, length: { maximum: 50 }
    validates :meal_dinner, length: { maximum: 50 }
    validates :meal_snack, length: { maximum: 50 }
    validates :exercise, length: { maximum: 50 }
    validates :memo, length: { maximum: 150 }


end

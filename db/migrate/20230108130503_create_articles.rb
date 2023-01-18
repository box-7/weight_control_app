class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.belongs_to :user, foreign_key: true
      t.date :date
      t.float :weight
      t.float :body_fat_percentage
      t.string :meal_morning
      t.string :meal_lunch
      t.string :meal_dinner
      t.string :meal_snack
      t.string :exercise
      t.string :memo

      t.timestamps
    end
  end
end

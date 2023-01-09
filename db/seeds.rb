# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


3.times do |n|
    User.create!(
        name: "テスト太郎#{n + 1}",
        email: "test#{n + 1}@test.com",
        admin:false,
        self_introduction: 'テキストテキストテキストテキスト',
        target_weight: 55.3,
        target_body_fat_percentage:10.0
        # image: File.open('./app/assets/images/test.jpg')
    )
end

User.all.each do |user|
    user.articles.create!(
        user_id: user.id,
        date: 'Wed, 03 Jan 2018',
        weight: 59.5,
        body_fat_percentage: 15.4,
        meal_morning: '朝ごはん',
        meal_lunch: '昼ごはん',
        meal_dinner: '夜ごはん',
        meal_snack: '間食',
        exercise: '運動',
        memo: 'メモ'

    )
end



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
        email: "test#{n + 1}@email.com",
        admin: false,
        password: 'password',
        self_introduction: 'テキストテキストテキストテキスト',
        target_weight: 55 + n * 5 ,
        target_body_fat_percentage: 15 + n * 3,
# image: 'user_#{n + 1}.png' → image: 'default.png'
# 前者のコードだとプロフィール画像を変更した時、gitに来てしまうため
        # image: 'user_#{n + 1}.png'
        image: 'default.png'
        # image: File.open('./app/assets/images/user#{n + 1}.jpg')
    )
end

User.all.each do |user|
    40.times do |n|
        # sample_date =  (Wed, 07 Dec 2022)
        # user.articles.create!だとユーザーもたくさん作成されてしまう
        Article.create!(
            user_id: user.id,
            date: Date.today - n,
            weight: 65 - 0.2 * n,
            body_fat_percentage: 20 - 0.1 * n,
            # weight: 65 - 0.2,
            # body_fat_percentage: 20 - 0.1,
            meal_morning: 'ご飯、味噌汁、納豆' + ' ' + (n + 1).to_s,
            meal_lunch: 'スパゲッティ' + ' ' + (n + 1).to_s,
            meal_dinner: '焼肉' + ' ' + (n + 1).to_s,
            meal_snack: 'プロテインチョコ' + ' ' + (n + 1).to_s,
            exercise: 'ランニング8km' + ' ' + (n + 1).to_s,
            memo: '順調に体重は落ちている' + ' ' + (n + 1).to_s
        )
    end
end

User.create!(
    name: "admin",
    email: "admin@email.com",
    admin: true,
    password: 'password',
    image: 'default.png'
)


# User.all.each do |user|
#     2.times do |n|
#         user.articles.create!(
#             user_id: user.id,
#             date: 'Wed, 07 Jan 2022',
#             # weight: 65 - 0.2 * n ,
#             # body_fat_percentage: 20 - 0.1 * n,
#             weight: 65 - 0.2,
#             body_fat_percentage: 20 - 0.1,
#             meal_morning: 'ご飯、味噌汁、納豆',
#             meal_lunch: 'スパゲッティ',
#             meal_dinner: '焼肉',
#             meal_snack: 'プロテインチョコ',
#             exercise: 'ランニング8km',
#             memo: '順調に体重は落ちている'
#         )
#     binding.pry
#     end
# end


# 3.times do |n|
#     User.create!(
#         name: "テスト太郎#{n + 1}",
#         email: "test#{n + 1}@test.com",
#         admin:false,
#         self_introduction: 'テキストテキストテキストテキスト',
#         target_weight: 55.3,
#         target_body_fat_percentage:10.0
#         # image: File.open('./app/assets/images/test.jpg')
#     )
# end

# User.all.each do |user|
#     user.articles.create!(
#         user_id: user.id,
#         date: 'Wed, 03 Jan 2018',
#         weight: 59.5,
#         body_fat_percentage: 15.4,
#         meal_morning: '朝ごはん',
#         meal_lunch: '昼ごはん',
#         meal_dinner: '夜ごはん',
#         meal_snack: '間食',
#         exercise: '運動',
#         memo: 'メモ'

#     )
# end







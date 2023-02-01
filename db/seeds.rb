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
        target_weight: 57 ,
        target_body_fat_percentage: 12,
# image: 'user_#{n + 1}.png' → image: 'default.png'
# 前者のコードだとプロフィール画像を変更した時、git変更情報が来てしまう
        # image: 'user_#{n + 1}.png'
        image: 'default.png'
        # image: File.open('./app/assets/images/user#{n + 1}.jpg')
    )
end

User.all.each do |user|
    menu = ['ご飯、味噌汁、納豆', '菓子パン', 'サンドイッチ', 'ケーキ', 'ラーメン', '焼肉', 'ご飯、しらす',
        'ハンバーガー', 'ケンタッキーフライドチキン', '鍋', '卵焼き', '玄米、ポタージュ', 'もつ鍋','あんこう鍋', 'おにぎり3個、野菜ジュース']
    weight = [70, 65, 60]
    percentage = [25, 20, 15]
    training = ['なし', 'ランニング8km', '腕立て、腹筋', 'ボクシング', '登山', 'ウォーキング5km', 'ヨガ', 'ゴールドジム']
    condition = ['快調', '体が重い', '疲れている','筋肉痛がひどい', '眠りが浅い', '便秘気味']

    base_weight = weight.sample
    base_percentage = percentage.sample
    40.times do |n|
            # sample_date =  (Wed, 07 Dec 2022)
            # user.articles.create!だとユーザーもたくさん作成されてしまう
        Article.create!(
            user_id: user.id,
            date: Date.today - n,
            weight: base_weight + n * 0.1,
            body_fat_percentage: base_percentage + n * 0.1,
            # weight: 65 - 0.2,
            # body_fat_percentage: 20 - 0.1,
            meal_morning: menu.sample,
            meal_lunch: menu.sample,
            meal_dinner: menu.sample ,
            meal_snack: menu.sample ,
            exercise: training.sample,
            memo: condition.sample + ' ' + (n + 1).to_s
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







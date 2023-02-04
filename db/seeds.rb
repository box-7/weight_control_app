
3.times do |n|
    User.create!(
        name: "テスト太郎#{n + 1}",
        email: "test#{n + 1}@email.com",
        admin: false,
        password: 'password',
        self_introduction: 'テキストテキストテキストテキスト',
        target_weight: 57 ,
        target_body_fat_percentage: 12,
# 前者のコードだとプロフィール画像を変更した時、gitに変更情報が来てしまう
        # image: 'user_#{n + 1}.png' エラーになる
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
    60.times do |n|
# sample_date =  (Wed, 07 Dec 2022)
# user.articles.create!だとユーザーもたくさん作成されてしまう
        if n % 3 == 0
            Article.create!(
                user_id: user.id,
                date: Date.today.end_of_month - n,
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
        else
            Article.create!(
                user_id: user.id,
                date: Date.today.end_of_month - n,
# weightを''で指定しないと、グラフがnilでエラーになる
                weight:'',
                body_fat_percentage:'',
            )
        end

    end
end

User.create!(
    name: "admin",
    email: "admin@email.com",
    admin: true,
    password: 'password',
    image: 'default.png'
)



# User.create!(
#     name: "グラフ確認10",
#     email: "test10@email.com",
#     admin: false,
#     password: 'password',
#     self_introduction: 'テキストテキストテキストテキスト',
#     target_weight: 57 ,
#     target_body_fat_percentage: 12,
# # 前者のコードだとプロフィール画像を変更した時、gitに変更情報が来てしまう
#     # image: 'user_#{n + 1}.png' エラーになる
#     image: 'default.png'
#     # image: File.open('./app/assets/images/user#{n + 1}.jpg')
# )

# test_user = User.find_by(email:"test10@email.com")
# menu = ['ご飯、味噌汁、納豆', '菓子パン', 'サンドイッチ', 'ケーキ', 'ラーメン', '焼肉', 'ご飯、しらす',
#     'ハンバーガー', 'ケンタッキーフライドチキン', '鍋', '卵焼き', '玄米、ポタージュ', 'もつ鍋','あんこう鍋', 'おにぎり3個、野菜ジュース']
# # weight = 70
# # percentage = 20
# training = ['なし', 'ランニング8km', '腕立て、腹筋', 'ボクシング', '登山', 'ウォーキング5km', 'ヨガ', 'ゴールドジム']
# condition = ['快調', '体が重い', '疲れている','筋肉痛がひどい', '眠りが浅い', '便秘気味']

# base_weight = 70
# base_percentage = 20
# 10.times do |n|
#     Article.create!(
#         user_id: test_user.id,
#         date: Date.today - n * 5,
#         weight: base_weight + n * 0.1,
#         body_fat_percentage: base_percentage + n * 0.1,

#         meal_morning: menu.sample,
#         meal_lunch: menu.sample,
#         meal_dinner: menu.sample ,
#         meal_snack: menu.sample ,
#         exercise: training.sample,
#         memo: condition.sample + ' ' + (n + 1).to_s
#     )
# end








# User.all.each do |user|
#     if user.email == "test10@email.com"
#         menu = ['ご飯、味噌汁、納豆', '菓子パン', 'サンドイッチ', 'ケーキ', 'ラーメン', '焼肉', 'ご飯、しらす',
#             'ハンバーガー', 'ケンタッキーフライドチキン', '鍋', '卵焼き', '玄米、ポタージュ', 'もつ鍋','あんこう鍋', 'おにぎり3個、野菜ジュース']
#         weight = 70
#         percentage = 20
#         training = ['なし', 'ランニング8km', '腕立て、腹筋', 'ボクシング', '登山', 'ウォーキング5km', 'ヨガ', 'ゴールドジム']
#         condition = ['快調', '体が重い', '疲れている','筋肉痛がひどい', '眠りが浅い', '便秘気味']

#         base_weight = weight.sample
#         base_percentage = percentage.sample
#         40.times do |n, day|
#                 # sample_date =  (Wed, 07 Dec 2022)
#                 # user.articles.create!だとユーザーもたくさん作成されてしまう
#             Article.create!(
#                 user_id: user.id,
#                 date: Date.today - day * 3,
#                 weight: base_weight + n * 0.1,
#                 body_fat_percentage: base_percentage + n * 0.1,
#                 # weight: 65 - 0.2,
#                 # body_fat_percentage: 20 - 0.1,
#                 meal_morning: menu.sample,
#                 meal_lunch: menu.sample,
#                 meal_dinner: menu.sample ,
#                 meal_snack: menu.sample ,
#                 exercise: training.sample,
#                 memo: condition.sample + ' ' + (n + 1).to_s
#             )
#         end
#     else
#         menu = ['ご飯、味噌汁、納豆', '菓子パン', 'サンドイッチ', 'ケーキ', 'ラーメン', '焼肉', 'ご飯、しらす',
#             'ハンバーガー', 'ケンタッキーフライドチキン', '鍋', '卵焼き', '玄米、ポタージュ', 'もつ鍋','あんこう鍋', 'おにぎり3個、野菜ジュース']
#         weight = [70, 65, 60]
#         percentage = [25, 20, 15]
#         training = ['なし', 'ランニング8km', '腕立て、腹筋', 'ボクシング', '登山', 'ウォーキング5km', 'ヨガ', 'ゴールドジム']
#         condition = ['快調', '体が重い', '疲れている','筋肉痛がひどい', '眠りが浅い', '便秘気味']

#         base_weight = weight.sample
#         base_percentage = percentage.sample
#         40.times do |n|
#                 # sample_date =  (Wed, 07 Dec 2022)
#                 # user.articles.create!だとユーザーもたくさん作成されてしまう
#             Article.create!(
#                 user_id: user.id,
#                 date: Date.today - n,
#                 weight: base_weight + n * 0.1,
#                 body_fat_percentage: base_percentage + n * 0.1,
#                 # weight: 65 - 0.2,
#                 # body_fat_percentage: 20 - 0.1,
#                 meal_morning: menu.sample,
#                 meal_lunch: menu.sample,
#                 meal_dinner: menu.sample ,
#                 meal_snack: menu.sample ,
#                 exercise: training.sample,
#                 memo: condition.sample + ' ' + (n + 1).to_s
#             )
#         end
#     end
# end


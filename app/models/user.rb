class User < ApplicationRecord
	has_many :articles, dependent: :destroy

    # メールアドレスの小文字化
    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { maximum: 20}
    # 正規表現のバリデーション / 定数, 最大値100
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 100 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: true
    # has_secure_passwordの機能を利用できるようにする
    has_secure_password
    # 最小文字数を指定
    validates :password, presence: true, length: { minimum: 6 }
    validates :password, presence: true
    validates :remember_digest, presence: true
end

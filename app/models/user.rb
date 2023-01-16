class User < ApplicationRecord
    # 「remember_token」という仮想の属性を作成
    attr_accessor :remember_token
	has_many :articles, dependent: :destroy

    # メールアドレスの小文字化
    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { maximum: 20}, uniqueness: true
    # 正規表現のバリデーション / 定数, 最大値100
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 100 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: true
    # has_secure_passwordの機能を利用できるようにする
    has_secure_password
    # 最小文字数を指定  allow_nil: true → updateではパスワードがなくても更新できる
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    # validates :remember_digest, presence: true

    # 渡された文字列のハッシュ値を返す
    def User.digest(string)
        cost =
        if ActiveModel::SecurePassword.min_cost
            BCrypt::Engine::MIN_COST
        else
            BCrypt::Engine.cost
        end
        BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # 永続セッションのためハッシュ化したトークンをデータベースに記憶
    # update_attribute # 1つのカラムの値を更新、validation なしに更新
    # update_attributes # 複数のカラムの値を更新できる、validation ありで更新
    def remember
        # remember_token は仮想属性(selfと組み合わせて変数のように使っている)
        self.remember_token = User.new_token # User.new_tokenメソッドを呼ぶ
        # 上記のupdate_attribute # remember_digestカラム # selfは省略できる
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # トークンがダイジェストと一致すればtrueを返す
    def authenticated?(remember_token)
        # ダイジェストが存在しない場合はfalseを返して終了
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end


    # ユーザーのログイン情報を破棄
    def forget
        update_attribute(:remember_digest, nil)
    end
end

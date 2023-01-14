# application_controllerで使えるように、module化している(自動生成)
module SessionsHelper
    # 引数に渡されたユーザーオブジェクトでログイン
    def log_in(user)
        # ユーザーidを返す
        session[:user_id] = user.id
    end

    # セッションと@current_userを破棄します
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end

    # 現在ログイン中のユーザーがいる場合オブジェクトを返す
    def current_user
        # 一時的セッションにユーザーIDが存在しない場合、 処理を終了しnilを返す
        if session[:user_id]
            # @current_userが存在しない時のみ右辺を参照する
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    # ヘルパーメソッド（logged_in?）
    # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
    def logged_in?
        # current_userがnilの場合は、!でfalseになる。存在する場合はtrueになる
        !current_user.nil?
    end

    # 永続的セッションを記憶
    def remember(user)
        # Userモデルを参照
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # 永続的セッションを破棄します
    def forget(user)
        user.forget # Userモデル参照
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
end
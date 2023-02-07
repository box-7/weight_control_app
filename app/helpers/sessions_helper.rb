# application_controllerで使えるように、module化している(自動生成)
module SessionsHelper
    # 引数に渡されたユーザーオブジェクトでログイン
    def log_in(user)
        # ユーザーidを返す
        session[:user_id] = user.id
    end

    # セッションと@current_userを破棄
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end


    # 現在ログイン中のユーザーがいる場合オブジェクトを返す
    def current_user
        # 一時的セッションにユーザーIDが存在しない場合、 処理を終了しnilを返す
        if session[:user_id]
            # @current_userが存在しない時のみ右辺を参照する
            @current_user ||= User.find_by(id: session[:user_id])
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def current_user?(user)
        # user == current_userだと、それぞれの中身が違うためエラーになる
        user.id == current_user.id
    end

    # ヘルパーメソッド（logged_in?）
    # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
    def logged_in?
        # current_userがnilの場合は、!でfalseになる。存在する場合はtrueになる
        !current_user.nil?
    end

    # 永続的セッションを記憶
    def remember(user)
        # User.rbのremember関数参照
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # 永続的セッションを破棄
    def forget(user)
        user.forget # User.rbのfoget関数参照
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
end
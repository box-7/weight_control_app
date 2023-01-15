class SessionsController < ApplicationController
  def new
  end

  def create
    # scope: :sessionをビューで設定しているので、params[:session]となる
    user = User.find_by(email: params[:session][:email].downcase)
      # 最初のuser → userが存在すればtrue、存在しなければfalseとなる / Rubyではnilとfalse以外のすべてのオブジェクトは、真偽値はtrueとなる
      # 後ろのuserはauthenticateメソッドでtrueかfalseか判断される
    if user && user.authenticate(params[:session][:password])
      # sessions_helperを叩く
      log_in user
      # [:remember_me] == '1'の場合 sessions_helperの、remember(user)、それ以外の場合 forget(user)を叩く
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # ログイン後にトップページにリダイレクト
      redirect_to root_path
    else
      # redirect_toではなく、renderを呼び出した場合
      # コントローラー側でflashにnowをつける
      # レンダリングが終わっているページで、フラッシュメッセージを追加で表示
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end

  def destroy
    # ログイン中の場合のみログアウト処理を実行
    if logged_in?
      log_out
      flash[:success] = 'ログアウトしました。'
    end
    redirect_to root_url
  end

end

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
  # 引数はストロングパラメーターで、ユーザーオブジェクトを生成し、インスタンス変数に代入
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログイン
      flash[:success] = '新規作成に成功しました。' # フラッシュメッセージを渡す
      # redirect_to user_url(@user) と同じ意味
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
end

  # ストロングパラメーター 入力できるカラムを制御する, :password_confirmation　.require(:user)
  def user_params
    # :password_confirmationはuserモデルには存在せず、new.html.erbに存在する項目
    # has_securepasswordで使用
    # そのためrequire(:user)は使えない → 使える
    # 入れると「ActionController::ParameterMissing in UsersController#new」エラーになる
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

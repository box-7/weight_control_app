class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
  # 引数はストロングパラメーターで、ユーザーオブジェクトを生成し、インスタンス変数に代入
    @user = User.new(user_params)
    # /user_images/は不要
    @user.image = "default.png"
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    # def createとは異なり、find文が必要
    @user = User.find(params[:id])
    if @user.update_attributes(user_update_params)
      # params[:image]ではなく、params[:user][:image]
      # 画像の保存の書き方に注意
      if params[:user][:image]
          @user.image = "user_#{@user.id}.png"
          # /public/user_images/の階層
          File.binwrite("public/user_images/#{@user.image}", params[:user][:image].read)
      end
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit
    end
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

  def user_update_params
    # strongパラメーターに:imageも入れる
    params.require(:user).permit(:name, :email, :password, :password_confirmation,:self_introduction, :target_weight, :target_body_fat_percentage, :image)
  end


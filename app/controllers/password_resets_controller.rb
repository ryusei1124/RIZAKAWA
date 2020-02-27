class PasswordResetsController < ApplicationController
  def new
  end

  def edit
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワードのリセット手順を記載したメールを送信しました"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりませんでした"
      render 'new'
    end
  end
end

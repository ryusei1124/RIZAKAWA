class UserMailer < ApplicationMailer
  def send_mail(user)
    @user = user
    mail(
      to: user.email,
      subject: '生徒登録完了しました'
    )
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードのリセット"
  end
end

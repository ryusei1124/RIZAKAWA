class UserMailer < ApplicationMailer
  def send_mail(user)
    @user = user
    mail(
      to: user.email,
      subject: '生徒登録完了しました'
    )
  end
end

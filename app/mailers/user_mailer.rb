class UserMailer < ApplicationMailer
  def send_mail(user, title, content, link)
    @user = user
    @title = title
    @content = content
    @link = link
    mail(
      to: user,
      subject: title
    )
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードのリセット"
  end
end

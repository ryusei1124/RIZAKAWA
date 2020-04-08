class UserMailer < ApplicationMailer
  def send_mail(user, title, content, link)
    @user = user #ここのみオブジェクト変数を設定のこと
    @title = title
    @content = content
    
    mail(
      to: user.email,
      subject: title
    )
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードのリセット"
  end
end

class UserMailer < ApplicationMailer
  def send_mail(user, title, content, link)
    url="https://rizakawa.herokuapp.com/"
    @user = user #ここのみオブジェクト変数を設定のこと
    @title = title
    @content = content
    @link=url+link
    
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

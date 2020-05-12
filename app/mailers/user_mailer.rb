class UserMailer < ApplicationMailer
  def send_mail(destination_user, send_user, bcc, title, content, link )
    url="https://rizakawa.herokuapp.com/"
    @destination_user = destination_user #オブジェクト変数を設定のこと
    @send_user = send_user #オブジェクト変数を設定のこと
    @bcc = bcc #メールアドレス
    @title = title
    @content = content
    @link = url+link
    mail(
      to: destination_user.email,
      bcc: bcc,
      subject: title)
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードのリセット"
  end
end

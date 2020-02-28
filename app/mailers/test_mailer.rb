class TestMailer < ApplicationMailer
  
  default from: '送信元のメールアドレス'
  
  def testmail(str)
    @str = str
    mail(to: "送信先のメールアドレス", subject: "メールの件名")
  end
end

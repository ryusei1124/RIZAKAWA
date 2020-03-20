# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def send_mail
     user = User.new(guardian: "侍 太郎")
    
     UserMailer.send_mail(user)
  end
end

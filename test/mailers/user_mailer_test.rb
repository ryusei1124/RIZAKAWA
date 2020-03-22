require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "send_mail" do
    user = users(:michael)
    mail = UserMailer.send_mail(user)
    assert_equal "生徒登録完了", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end

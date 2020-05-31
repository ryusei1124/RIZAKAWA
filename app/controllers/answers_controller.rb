class AnswersController < ApplicationController
  before_action :mail_link_host,   only: [:create]
  
  def create
    @answer = Answer.new(answer_params)
    @answer.user_id = current_user.id
    @answer.student_id = current_user.id
    if @answer.save
      @title = "お問い合わせの登録がありました"
      @content = "お問い合わせの登録がありました。下記リンクの確認をお願いします。"
      send_mail_address
      flash[:success] = "登録に成功し、通知メールを送付しました"
    else
      flash[:warning] = "返信に失敗しました"
    end
    redirect_to request.referrer
  end

  def answer_params
     params.permit(:answer_content, :question_id, :user_id, :student_id)
  end
  
  def send_mail_address
      question = Question.find( @answer.question_id )
      #ログインユーザー(current_user.id)と問い合わせ者(question.user_id)が同じ場合　宛先は問い合わせ先の宛先
      if current_user.id == question.user_id
        @destination_user = User.find( question.destination )
      #ログインユーザー(current_user.id)と問い合わせ者(question.user_id)が異なる場合　宛先は問い合わせ先の問い合わせユーザー
      else 
        @destination_user = User.find( question.user_id )
      end
      if current_user.admin?
        @bcc = User.find(1).email
      else
        @bcc = ""
      end
      @send_user =  current_user
      link = "questions"
      @link = @url + link
      UserMailer.send_mail( @destination_user, @send_user, @bcc, @title, @content,@link).deliver_now
  end
end

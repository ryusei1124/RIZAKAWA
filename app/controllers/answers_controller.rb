class AnswersController < ApplicationController
  def create
    answer = Answer.new(answer_params)
    answer.user_id = current_user.id
    if answer.save
      flash[:success] = "コメント登録に成功し、お知らせメールを送信しました"
      # user_id = Question.find(answer.reservation_id).user_id
    else
      flash[:warning] = "投稿に失敗しました"
    end
    redirect_to request.referrer
  end

  def answer_params
     params.permit(:answer_content, :question_id, :user_id)
  end
end

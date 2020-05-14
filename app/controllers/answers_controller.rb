class AnswersController < ApplicationController
  def create
    answer = Answer.new(answer_params)
    answer.user_id = current_user.id
    answer.student_id = current_user.id
    if answer.save
      flash[:success] = "返信しました"
    else
      flash[:warning] = "返信に失敗しました"
    end
    redirect_to request.referrer
  end

  def answer_params
     params.permit(:answer_content, :question_id, :user_id, :student_id)
  end
end

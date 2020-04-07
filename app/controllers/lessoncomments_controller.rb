class LessoncommentsController < ApplicationController
  def create
    lessoncomment = Lessoncomment.new(lessoncomment_params)
    lesson.user_id=current_user.id
    if Lessoncomment.save
      flash[:success]="コメント登録に成功しました"
      redirect_to request.referrer
    end
  end


  def lessoncomment_params
     params.require(:lessoncomment).permit(:content, :lesson_id, :reservation_id, :student_id)
  end
end

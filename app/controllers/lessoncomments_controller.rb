class LessoncommentsController < ApplicationController
  def create
    lessoncomment = Lessoncomment.new(lessoncomment_params)
    lessoncomment.user_id = current_user.id
    if lessoncomment.save
      @user=User.find(lessoncomment.user_id)
      @user=User.find(18) if @user.admin==false
      name=@user.guardian+"様から"
      title = "#{name}授業へのコメントがありました"
      content = "授業に関するコメントが投稿されました。"
      link="reservationusers/useredit?lesson_id=#{lessoncomment.lesson_id}&student_id=#{lessoncomment.student_id}"
      UserMailer.send_mail(@user, title, content,link ).deliver_now
      flash[:success] = "コメント登録に成功しました"
    else
      flash[:warning] = "登録に失敗しました"
    end
    redirect_to request.referrer
  end
  
  def lessoncomment_params
     params.require(:lessoncomment).permit(:content, :lesson_id, :reservation_id, :student_id)
  end
end

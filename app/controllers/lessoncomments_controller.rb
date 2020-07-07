class LessoncommentsController < ApplicationController
  before_action :mail_link_host,   only: [:create]

  def create
    lessoncomment = Lessoncomment.new(lessoncomment_params)
    lessoncomment.user_id = current_user.id
    if lessoncomment.save
      user_id = Reservation.find(lessoncomment.reservation_id).user_id
      admin_user = User.find(1)
      normal_user = User.find(user_id) 
      if  current_user.admin == false
       @destination_user = admin_user
       @send_user =  normal_user
      else
       @destination_user = normal_user
       @send_user =  admin_user
      end  
      title = "授業へのコメントがありました"
      content = "授業に関するコメントが投稿されました。"
      link = "reservationusers/useredit?reservation_id=#{lessoncomment.reservation_id}&student_id=#{lessoncomment.student_id}"
      @link = @url + link
      bcc = ""
      UserMailer.send_mail(@destination_user, @send_user, bcc, title, content, @link).deliver_now
      flash[:success] = "コメント登録に成功し、お知らせメールを送信しました"
    else
      flash[:warning] = "登録に失敗しました"
    end
    redirect_to request.referrer
  end
  
  def lessoncomment_params
     params.require(:lessoncomment).permit(:content, :lesson_id, :reservation_id, :student_id)
  end
end

class ReservationusersController < ApplicationController
  include ApplicationHelper
  before_action :unless_login
  before_action :unless_student,   only: [:useredit]
  before_action :weekday,   only: [:useredit]
  require 'date'
  
  def useredit
    @lessonlists=[]
    session[:student_id]=@student.id
    lesson_id=params[:lesson_id]
    @lesson=Lesson.find(lesson_id)
    @lessons=Lesson.includes(:reservations).all
    @reservation=Reservation.find_by(lesson_id:@lesson.id, student_id:@student.id)
    @zoomnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).count
    @realnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).count
    @today=Date.today
    @lessoncomment=Lessoncomment.new
    #コメント抽出
    @lessoncomments=Lessoncomment.where("lesson_id =? and student_id=?" ,@lesson.id,@student.id)
    #振替のためのコード。授業の日に該当生徒が小学生か中学生かを取得。
    gradesc=gradeschool(@student.birthday,@lesson.meeting_on)
    lessons=Lesson.where("meeting_on> ? and regular= ?", @today,true).where("target= ? or target= ?", gradesc,"小中学生").where("examinee is null or examinee= ?",@student.examinee) .order(:meeting_on).order(:started_at)
    lessons.each do |les|
      if Reservation.where("student_id= ? and lesson_id= ?", @student.id,les.id).count==0
        realcapacity=Lesson.find(lesson_id).seats_real
        overcapacity="〇"
        overcapacity="×" if (realcapacity-Reservation.where("lesson_id= ? and zoom=?",les.id,false).count)<0
        content=overcapacity+les.meeting_on.to_s+"("+weekdate(les.meeting_on)+")"+timedisplay(les.started_at).to_s+"～"+timedisplay(les.finished_at).to_s+"　リアル"
        @lessonlists << Listcollection.new(les.id.to_s+"-1",content,false)
        overcapacity="〇"
        overcapacity="×" if (realcapacity-Reservation.where("lesson_id= ? and zoom=?",les.id,true).count)<0
        content=overcapacity+les.meeting_on.to_s+"("+weekdate(les.meeting_on)+")"+timedisplay(les.started_at).to_s+"～"+timedisplay(les.finished_at).to_s+"　ZOOM"
        @lessonlists << Listcollection.new(les.id.to_s+"-2",content,true)
      end
    end
  end
  
  def userupdate
    reservation_id=params[:reservation_id]
    if params[:commit] == "リアルに変更する"
      zoom=false
    else
      zoom=true
    end
    reservation=Reservation.find(reservation_id)
    reservation.zoom=zoom
    if reservation.save
      flash[:success]="受講方法を変更しました"
    else
      flash[:danger]="受講方法に失敗しました。"
    end
    redirect_to request.referrer
  end
  
  def reservation_change_user
    reservation_id=params[:reservation_id]
    transfer_day_id=params[:id]
    reservation=Reservation.find(reservation_id)
    student_id=params[:student_id]
    #振替日がブランクだった場合の処理
    if transfer_day_id.blank?
      #予約情報を削除
      reservation.destroy
      student=Student.find(student_id)
      #生徒のキャンセル保有数をプラス１
      if student.cancelnumber.present?
        student.cancelnumber=student.cancelnumber+1
      else
        student.cancelnumber=1
      end
      lesson=Lesson.find(reservation.lesson_id)
      lesson_meeting_on=lesson.meeting_on
      if reservation.save and student.save
        flash[:success]="キャンセル登録しました。別途振替授業を登録願います。"
      else
        flash[:success]="キャンセル登録に失敗しました。"
      end
    else
      reservationarray=transfer_day_id.split("-")
      reservation.lesson_id=reservationarray[0].to_i
      reservation.lesson_id=reservationarray[0].to_i
      if reservationarray[1]=="1"
        reservation.zoom=false
      else
        reservation.zoom=true
      end
      reservation.fix_time=nil
      reservation.transfer=true
      lesson=Lesson.find(reservation.lesson_id)
      lesson_meeting_on=lesson.meeting_on
      #キャンセル待ち登録
      if lesson.seats_zoom<Reservation.where("lesson_id= ? and zoom=?",lesson.id,true).count or  lesson.seats_real<Reservation.where("lesson_id= ? and zoom=?",lesson.id,false).count
        reservation.waiting=true
      else 
        reservation.waiting=false
      end
      if reservation.save
        flash[:success]="#{lesson.meeting_on.to_s}に受講日を振替しました。確認願います。"
        flash[:warning]="キャンセル待ちになります" if reservation.waiting==true
      else
        flash[:danger]="受講日振替に失敗しました"
      end
    end
    redirect_to "/lessons/weeklyschedule?cation=1&changeday=#{lesson_meeting_on.to_s}"
  end
  def reservation_delete
    reservation_id=params[:reservation_id]
    reservation=Reservation.find(reservation_id)
    lesson=Lesson.find(reservation.lesson_id)
    #予約情報を削除
    reservation.destroy
    flash[:danger]="キャンセル登録しました"
    redirect_to "/lessons/weeklyschedule?cation=1&changeday=#{lesson.meeting_on.to_s}"
  end
  
  def reservationnewuser
    @reservation=Reservation.new
    @student_id=params[:student_id]
    @student=Student.find(@student_id)
    @lesson_id=params[:lesson_id]
    @lesson=Lesson.find(@lesson_id)
  end
  
  def reservationnewusercreate
    student=Student.find(params[:student_id])
    lesson=Lesson.find(params[:lesson_id])
    zoom=tob(params[:zoom])
    user_id=student.user_id
    #定例授業の場合キャンセル登録ポイントマイナス１
    #student.cancelnumber=student.cancelnumber-1 if lesson.regular==true
    reservation=Reservation.new(student_id:student.id,lesson_id:lesson.id,zoom:zoom,user_id:user_id)
    if reservation.save
      flash[:success]="#{lesson.meeting_on.to_s}に受講日を登録しました。確認願います。"
    else
      flash[:danger]="受講日登録に失敗しました"
    end
    redirect_to "/lessons/weeklyschedule?cation=1&changeday=#{lesson.meeting_on.to_s}"
  end
end


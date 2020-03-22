class ReservationsController < ApplicationController
  include ApplicationHelper
  before_action:unless_login
  require 'date'
  
  def index
  end
  
  def reservations_log
  end
  
  def useredit
    student_id=params[:student_id]
    @student=Student.find(student_id)
    @lessonlists=[]
    lesson_id=params[:lesson_id]
    @lesson=Lesson.find(lesson_id)
    @lessons=Lesson.includes(:reservations).all
    @reservation=Reservation.find_by(lesson_id:@lesson.id, student_id:@student.id)
    @zoomnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).count
    @realnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).count
    today=Date.today
    #振替のためのコード。授業の日に該当生徒が小学生か中学生かを取得。
    gradesc=gradeschool(@student.birthday,@lesson.meeting_on)
    lessons=Lesson.where("meeting_on> ? and regular= ?", today,true).where("target= ? or target= ?", gradesc,"小中学生").where("examinee is null or examinee= ?",@student.examinee) .order(:meeting_on).order(:started_at)
    lessons.each do |les|
      if Reservation.where("student_id= ? and lesson_id= ?", @student.id,les.id).count==0
        realcapacity=Lesson.find(lesson_id).seats_real
        overcapacity="○"
        overcapacity="×" if (realcapacity-Reservation.where("lesson_id= ? and zoom=?",les.id,false).count)<0
        content=overcapacity+les.meeting_on.to_s+"("+weekdate(les.meeting_on)+")"+timedisplay(les.started_at).to_s+"～"+timedisplay(les.finished_at).to_s+"　リアル"
        @lessonlists << Listcollection.new(les.id.to_s+"-1",content,false)
        overcapacity="○"
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
    reservation=Reservation.find(params[:reservation_id])
    reservationarray=params[:id].split("-")
    reservation.lesson_id=reservationarray[0].to_i
    if reservationarray[1]=="1"
      reservation.zoom=false
    else
      reservation.zoom=true
    end
    reservation.transfer=true
    lesson=Lesson.find(reservation.lesson_id)
    if reservation.save
      flash[:success]="#{lesson.meeting_on.to_s}に受講日を振替しました。確認願います。"
    else
      flash[:success]="受講日振替に失敗しました"
    end
    redirect_to "/lessons/weeklyschedule?cation=1&changeday=#{lesson.meeting_on.to_s}"
  end
  
end
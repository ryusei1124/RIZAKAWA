class ReservationsController < ApplicationController
  include ApplicationHelper
  before_action:unless_login
  
  def index
  end
  
  def reservations_log
  end
  
  def useredit
    student_id=params[:student_id]
    @student=Student.find(student_id)
    lesson_id=params[:lesson_id]
    @lesson=Lesson.find(lesson_id)
    @lessons=Lesson.all
    @reservation=Reservation.find_by(lesson_id:@lesson.id, student_id:@student.id)
    @zoomnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).count
    @realnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).count
    @lessonlist=Lesson.joins(:reservations).merge(Reservation.where.not("student_id=?",@student.id)).order(:meeting_on)
  end
  
  def userupdate
    reservation_id=params[:reservation_id]
    if params[:commit] == "リアルに変更する"
      zoom=false
    else
      zoom=true
    end
    @beforesite=params[:beforesite]
    reservation=Reservation.find(reservation_id)
    reservation_zoom_before=reservation.zoom
    reservation.zoom=zoom
    
    if reservation.save
      if reservation_zoom_before!=reservation.zoom 
        flash[:success]="受講方法を変更しました"
      else
        flash[:warning]="受講方法の変更はありません"
      end
    else
      flash[:danger]="受講方法に失敗しました。"
    end
    redirect_to request.referrer
  end
  
end
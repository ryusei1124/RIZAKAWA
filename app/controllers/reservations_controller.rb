class ReservationsController < ApplicationController
<<<<<<< HEAD

=======
  include ApplicationHelper
  before_action:unless_login
  
  def index
  end
  
>>>>>>> 21c8c14d506ed4e688553ac0329e0dce50030364
  def reservations_log
  end
  
  def useredit
    student_id=params[:student_id]
    @student=Student.find(student_id)
    lesson_id=params[:lesson_id]
    @lesson=Lesson.find(lesson_id)
    @reservation=Reservation.find_by(lesson_id:@lesson.id, student_id:@student.id)
    @zoomnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).count
    @realnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).count
  end
  def userupdate
    reservation_id=params[:reservation_id]
    zoom=params[:zoom]
    @beforesite=params[:beforesite]
    reservation=Reservation.find(reservation_id)
    reservation.zoom=tob(zoom)
    if reservation.save
      flash[:success]="受講方法を変更しました"
    else
      flash[:danger]="受講方法に失敗しました。"
    end
    redirect_to request.referrer
  end
  
end
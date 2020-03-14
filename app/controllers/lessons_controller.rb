class LessonsController < ApplicationController
  before_action :schoolgrade
  before_action:set_student
  require 'date'
  include ApplicationHelper
  
  def weeklyschedule
    if params[:cation]=="1"
      @today=params[:changeday].to_date
    else
      @today = Date.today
    end
    if params[:cation]=="2"
      studentid=params[:changestudent]
      session[:student_id]=Student.find_by(id:studentid).id if studentid.present?
      @student=Student.find(session[:student_id])
      flash[:warning]="#{ @student.student_name}に切替成功しました。"
    end
    @students=Student.where(user_id:current_user)
    if @students.blank?
      session[:student_id]= nil
    elsif session[:student_id].blank?
      @student=@students.first
      session[:student_id]=Student.find(@student.id).id
    end
    @lesson=Lesson.new
    @lessons=Lesson.all
    @hourselect=timeselect(10,22)
    @capacity=[*0..30]
    @regular=["定例","臨時"]
    @target=["小学生","中学生","小中学生"]
  end
  
  def create
    lesson = Lesson.new(lesson_params)
    lesson.user_id=current_user.id
    starttime=lesson_params[:starttime].to_time
    finishtime=lesson_params[:finishtime].to_time
    lesson.started_at=starttime+54000
    lesson.finished_at=finishtime+54000
    lesson.regular=false if lesson_params[:regularkanji]=="臨時"
    if lesson.save
      flash[:success]="登録に成功しました"
      if lesson.regular?
        if lesson_params[:target]=="中学生"
          rev=Student.where("fix_day =? AND birthday < ?" ,weekdate(lesson.meeting_on), jrhigh(lesson.meeting_on).to_date)
        elsif lesson_params[:target]=="小学生"
          rev=Student.where("fix_day =? AND birthday >= ?", weekdate(lesson.meeting_on), jrhigh(lesson.meeting_on).to_date)
        else
          rev=Student.where("fix_day =? AND leave_time= ?", weekdate(lesson.meeting_on))
        end
        rev.each do |revtion|
          if revtion.leave_time.blank?
            reservation=Reservation.new(student_id:revtion.id,lesson_id:lesson.id,zoom:revtion.zoom,user_id:revtion.user_id)
            if reservation.save
              flash[:warning]="該当受講生の予約登録に成功しました。"
            else
              flash[:warning]="該当受講生の予約登録に失敗しました。"
            end
          end
        end
      end
    else
      flash[:warning]="登録に失敗しました"
    end
    redirect_to request.referrer
  end
  
  private
  def lesson_params
     params.require(:lesson).permit(:meeting_on, :target,:starttime,:finishtime,:seats_real,:seats_zoom,:regularkanji,:note)
  end
end

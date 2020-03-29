class AttendancesController < ApplicationController
  #before_action :set_student
  def lesson_detail
    @target=["小学生","中学生","小中学生"]
    @today = Date.today
    @lesson = Lesson.find_by(params[:id])
    
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
    
    @capacity=[*0..30]
    @regular=["定例","臨時"]
    @target=["小学生","中学生","小中学生"]
  end
end

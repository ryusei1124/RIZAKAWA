class ManegerStudentsController < ApplicationController
  before_action :fix_check,   only: [:update]
  
  def update
    @student = Student.find(student_params[:id])
    @lesson = Lesson.find(lesson_params[:id])
    @lesson.note = lesson_params[:note]
    if @fix_check == 1
      flash[:danger] = "入力に不備あり、更新は失敗しました。再度更新願います。"
    elsif @student.update(student_params) && @lesson.save
      flash[:success] = "更新に成功しました"
    else
      flash[:warning] = "更新に失敗しました"
    end
    redirect_to request.referrer
  end

  private
  def student_params
     params.require(:student).permit( :id, :school, :zoom, :examinee, :fix_day, :fix_time, :fix_finishtime, :fix_day2, :fix_time2,:fix_finishtime2, :fix_day3, :fix_time3,:fix_finishtime3, :fix_day4, :fix_time4, :fix_finishtime4,  :fix_day5, :fix_time5, :fix_finishtime5, :note)
  end
  def lesson_params
     params.require(:lesson).permit( :id, :note)
  end
  
end

class ManegerStudentsController < ApplicationController
  before_action :fix_check,   only: [:update]
  
  def update
    @lesson = Lesson.find(lesson_params[:id])
    @lesson.note = lesson_params[:note]
    if @fix_check == 1
      flash[:danger] = "#{@student.student_name}の更新は失敗しました。"
    elsif @student.update(student_params) && @lesson.save
      flash[:success] = "更新に成功しました"
    else
      flash[:warning] = "更新に失敗しました"
    end
    redirect_to request.referrer
  end

  private
  def student_params
     params.require(:student).permit( :id, :school, :zoom, :examinee, :fix_day, :fix_time, :fix_day2, :fix_time2, :fix_day3, :fix_time3, :fix_day4, :fix_time4, :note)
  end
  def lesson_params
     params.require(:lesson).permit( :id, :note)
  end
  
end

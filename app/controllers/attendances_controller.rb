class AttendancesController < ApplicationController
  #before_action :set_student
  def lesson_detail
    @target=["小学生","中学生","小中学生"]
    @today = Date.today
    @lesson = Lesson.find_by(params[:id])
  end
end

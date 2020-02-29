class LessonsController < ApplicationController
  before_action :schoolgrade
  require 'date'
  include ApplicationHelper
  
  def weeklyschedule
    @today = Date.today
    @lesson=Lesson.new
    @lessons=Lesson.all
    @hourselect=timeselect(10,23)
    @capacity=[*0..30]
    @regular=["定例","臨時"]
    @target=["小学生","中学生","小中学生"]
  end
  def create
    lesson = Lesson.new(lesson_params)
    lesson.user_id=current_user.id
    starttime=lesson_params[:starttime].to_time
    finishtime=lesson_params[:finishtime].to_time
    lesson.started_at=starttime
    lesson.finished_at=finishtime
    lesson.regular=false if lesson_params[:regularkanji]=="臨時"
    if lesson.save
      flash[:success]="登録に成功しました"
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

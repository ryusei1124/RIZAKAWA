class LessonsController < ApplicationController
  before_action :schoolgrade
  require 'date'
  include ApplicationHelper
  
  def weeklyschedule
    if params[:cation]=="1"
      @today=params[:changeday].to_date
    else
      @today = Date.today
    end
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
      if lesson.regular?
        if lesson_params[:target]=="中学生"
          rev=User.where("fix_day =? AND birthday < ?", weekdate(lesson.meeting_on), jrhigh(lesson.meeting_on).to_date)
        elsif lesson_params[:target]=="小学生"
          rev=User.where("fix_day =? AND birthday >= ?", weekdate(lesson.meeting_on), jrhigh(lesson.meeting_on).to_date)
        else
          rev=User.where(fix_day=weekdate(lesson.meeting_on))
        end
        rev.each do |revtion|
        Reservation.create(user_id:revtion.id,lesson_id:lesson.id)
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

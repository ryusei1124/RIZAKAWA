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
    openday=lesson_params[:meeting_on]
    lesson.started_at=starttime+54000
    lesson.finished_at=finishtime+54000
    if lesson_params[:examineekanji]=="受験生"
      lesson.examinee=true
    elsif lesson_params[:examineekanji]=="全"
      lesson.examinee=nil
    end
    
    lesson.regular=false if lesson_params[:regularkanji]=="臨時"
    #30分毎重複チェック
    starttimec=lesson.started_at
    finishtimec=lesson.finished_at
    reservecounttotal=0
    count=1
    while starttimec<=finishtimec
      reservecount=Lesson.where("started_at =? AND meeting_on = ?" ,starttimec, openday).count
      #一回目のスタートタイムが前の授業の終わりと一緒でも登録必要にてそのまま通す
      if count==1
        count=2
      else
        reservecount=Lesson.where("finished_at =? AND meeting_on = ?" ,starttimec, openday).count
      end  
      starttimec=starttimec+1800
      reservecounttotal=reservecounttotal+reservecount
    end
    #重複があれば処理を中止し週間予定表に戻る
    if reservecounttotal>=1
      flash[:danger]="重複登録があります。処理を中止しました。"
    elsif lesson.save
      flash[:success]="登録に成功しました"
      dayofweek=weekdate(lesson.meeting_on)
      if lesson.regular? #定例授業なら該当の生徒を自動で登録する
        #会員で該当曜日３つカラムから該当曜日の生徒抽出
        students=Student.where("fix_day =? OR fix_day2 =? OR fix_day3 =?",dayofweek,dayofweek,dayofweek).where(withdrawal:nil)
        if lesson_params[:target]=="中学生" && lesson.examinee==true #中学生で受験生を自動登録
          rev=students.where("birthday < ? and examinee=?" ,jrhigh(lesson.meeting_on).to_date,true)
        elsif lesson_params[:target]=="中学生" && lesson.examinee==false #中学生で受験生以外を自動登録
          rev=students.where("birthday < ? and examinee=?" , jrhigh(lesson.meeting_on).to_date,false)
        elsif lesson_params[:target]=="中学生" && lesson.examinee.nil? #中学生を自動登録
          rev=students.where("birthday < ? " , jrhigh(lesson.meeting_on).to_date)  
        elsif lesson_params[:target]=="小学生" and lesson.examinee==true #小学生で受験生を自動登録
          rev=students.where("birthday >= ? and examinee=?", jrhigh(lesson.meeting_on).to_date,true)
        elsif lesson_params[:target]=="小学生" and lesson.examinee==false #小学生で受験生以外を自動登録
          rev=students.where("birthday >= ? and examinee=?", jrhigh(lesson.meeting_on).to_date,false)
        elsif lesson_params[:target]=="小学生" and lesson.examinee.nil? #小学生を自動登録
          rev=students.where("birthday >= ?", jrhigh(lesson.meeting_on).to_date)  
        else
          rev=students
        end
      end
      rev.each do |revtion|
        if revtion.fix_day==dayofweek
          fixtime=revtion.fix_time
        elsif revtion.fix_day2==dayofweek
          fixtime=revtion.fix_time2
        else
          fixtime=revtion.fix_time3
        end
        reservation=Reservation.new(student_id:revtion.id,lesson_id:lesson.id,zoom:revtion.zoom,user_id:revtion.user_id,fix_time:fixtime)
        if reservation.save
          flash[:warning]="該当受講生の予約登録に成功しました。"
        else
          flash[:danger]="該当受講生の予約登録に失敗しました。"
        end
      end
    else
      flash[:warning]="登録に失敗しました"
    end
    redirect_to request.referrer
  end
  
  private
  def lesson_params
     params.require(:lesson).permit(:meeting_on, :target,:examineekanji,:starttime,:finishtime,:seats_real,:seats_zoom,:regularkanji,:note)
  end
end

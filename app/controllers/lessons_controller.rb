class LessonsController < ApplicationController
  before_action :schoolgrade
  before_action :set_student
  before_action :set_lesson
  before_action :admin_user, only: %i(lesson_detail)
  before_action :unless_login
  before_action :mail_link_host,   only: [:cancellation]
  require 'date'
  include ApplicationHelper
  
  def weeklyschedule
    @timecol = TIMECOL
    if params[:cation] == "1"
      @today=params[:changeday].to_date
    else
      nowtime=Time.new+@timecol
      @today = nowtime.to_date
    end
    if params[:cation]=="2"
      studentid=params[:changestudent]
      session[:student_id]=Student.find_by(id:studentid).id if studentid.present?
      @student=Student.find(session[:student_id])
      flash[:warning]="#{ @student.student_name }に切替成功しました。"
    end
    @students=Student.where(user_id:current_user).under_contact_createorder
    if @students.blank?
      session[:student_id]= nil
    elsif session[:student_id].blank?
      @student=@students.first
      session[:student_id]=Student.find(@student.id).id
    end
    @first_time="2000-01-01 10:00".to_time
    @last_time="2000-01-01 22:30".to_time
    @lesson=Lesson.new
    @lessons=Lesson.all
  end
  
  def create
    starttime = lesson_params[:starttime].to_time
    finishtime = lesson_params[:finishtime].to_time
    autoregister = lesson_params[:autoregister]
    @openday = lesson_params[:meeting_on].to_date
    fixtimeres = lesson_params[:fixtimeres]
    regularkanji = lesson_params[:regularkanji]
    registration_check = lesson_params[:registration_check]
    registrations_day = lesson_params[:registrations]
    if lesson_params[:examineekanji] == "受験生"
      examinee = true
    elsif lesson_params[:examineekanji] == "全"
      examinee = nil
    else
      examinee = false
    end
    if registration_check == "1"
      last_day = registrations_day.to_date
    else
      last_day = @openday.to_date
    end
    while @openday <= last_day do
      @lesson = Lesson.new(lesson_params)
      @lesson.user_id = current_user.id
      @lesson.meeting_on = @openday
      @lesson.started_at = starttime + 54000
      @lesson.finished_at = finishtime + 54000
      @lesson.regular = false if regularkanji == "臨時"
      @lesson.examinee = examinee
      #30分毎重複チェック
      @lesson_id = 0
      @reservecount = 0
      @reservecounttotal = 0
      duplication_check
      #重複があれば処理を中止し週間予定表に戻る
      if @reservecounttotal >= 1
        flash[:danger]="重複登録や時間設定の不備で登録できなかった授業があります"
      elsif @lesson.save
        flash[:success]="登録に成功しました"
        dayofweek=weekdate(@lesson.meeting_on)
        if @lesson.regular? and autoregister == "1" #定例授業なら該当の生徒を自動で登録する
          #会員で該当曜日３つカラムから該当曜日の生徒抽出
          students = Student.where("fix_day =? or fix_day2 =? or fix_day3 =? or fix_day4 =?",dayofweek,dayofweek,dayofweek,dayofweek).under_contact
          if fixtimeres=="1" #固定時間のあってる人のみ抽出し自動登録
            students=students.where("fix_time >=? and fix_time < ?", @lesson.started_at,@lesson.finished_at)
            .or(students.where("fix_time2 >=? and fix_time2 < ?", @lesson.started_at,@lesson.finished_at))
            .or(students.where("fix_time3 >=? and fix_time3 < ?", @lesson.started_at,@lesson.finished_at))
            .or(students.where("fix_time4 >=? and fix_time4 < ?", @lesson.started_at,@lesson.finished_at))
          end
          
          if lesson_params[:target] == "中高生" and @lesson.examinee == true #中学生、高校生で受験生を自動登録
            rev=students.where("birthday < ? and examinee = ?" ,jrhigh(@lesson.meeting_on).to_date,true)
          elsif lesson_params[:target] == "中高生" and @lesson.examinee == false #中学生、高校生で受験生以外を自動登録
            rev=students.where("birthday < ? and examinee = ?" , jrhigh(@lesson.meeting_on).to_date,false)
          elsif lesson_params[:target] == "中高生" and @lesson.examinee.nil? #中学生、高校生を自動登録
            rev=students.where("birthday < ? " , jrhigh(@lesson.meeting_on).to_date)  
          elsif lesson_params[:target] == "小学生" and @lesson.examinee == true #小学生で受験生を自動登録
            rev=students.where("birthday >= ? and examinee=?", jrhigh(@lesson.meeting_on).to_date,true)
          elsif lesson_params[:target] == "小学生" and @lesson.examinee == false #小学生で受験生以外を自動登録
            rev=students.where("birthday >= ? and examinee=?", jrhigh(@lesson.meeting_on).to_date,false)
          elsif lesson_params[:target] == "小学生" and @lesson.examinee.nil? #小学生を自動登録
            rev=students.where("birthday >= ?", jrhigh(@lesson.meeting_on).to_date)  
          else
          rev=students
        end
        rev.each do |revtion|
          if revtion.fix_day == dayofweek
            fixtime = revtion.fix_time
          elsif revtion.fix_day2 == dayofweek
            fixtime = revtion.fix_time2
          else
            fixtime = revtion.fix_time3
          end
          reservation = Reservation.new(student_id:revtion.id,lesson_id:@lesson.id,zoom:revtion.zoom,user_id:revtion.user_id,fix_time:fixtime)
          if reservation.save
            flash[:warning] = "該当受講生の予約登録に成功しました。"
          else
            flash[:danger] = "該当受講生の予約登録に失敗しました。"
          end
        end
      end
      else
        flash[:warning] = "登録に失敗しました"
      end
      @openday = @openday.since(7.days)
    end 
    redirect_to request.referrer
  end
  
  def lesson_detail
    @lesson = Lesson.find(params[:id])
    @reservations = Reservation.where("lesson_id = ?", @lesson.id).cancel_exclusion.fix_time_order
    @reservations_cancelonly = Reservation.where("lesson_id = ?", @lesson.id).cancel_only
    @zooms_sum = Reservation.where("lesson_id = ? and zoom = ?", @lesson.id,true).cancel_exclusion.count
    @reals_sum = Reservation.where("lesson_id = ? and zoom = ?", @lesson.id,false).cancel_exclusion.count
    @students_add = Student.kanaorder
    @waiting = Reservation.where("lesson_id = ? and waiting = ?", @lesson.id, true).count
    @student_lists = Array.new()
    @students = Student.kanaorder
    @students.each do | st |
      if  @reservations.find_by( student_id: st.id ).blank?
        id = st.id
        student_name = st.student_name + "(" + Student.gradeyear( st.id ) + ")" 
        @student_lists << Studentlist.new( id, student_name )
      end
    end
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson_id = @lesson.id
    @lesson.meeting_on = lesson_params[:meeting_on]
    @lesson.started_at = lesson_params[:starttime]
    @lesson.finished_at = lesson_params[:finishtime]
    @openday = @lesson.meeting_on
    @lesson.seats_real = lesson_params[:seats_real]
    @lesson.seats_zoom = lesson_params[:seats_zoom]
    @lesson.note = lesson_params[:note]
    @lesson.rescheduled = true
    @reservecount = 0
    @reservecounttotal = 0
    duplication_check
    if @reservecounttotal >= 1 
      flash[:danger] = "重複登録があります。処理を中止します"
    elsif @lesson.save
      flash[:success] = "更新に成功しました"
    else
      flash[:danger] = "更新に失敗しました"
    end
    redirect_to request.referrer
  end

  def cancellation
    lesson = Lesson.find(params[:id])
    if params[:cancel] == "Yes"
      lesson.cancel = true
    else
      lesson.cancel = false
    end
    if lesson.save
      if lesson.cancel?
       title = "授業を中止にします"
       content = "#{daydis(lesson.meeting_on)}#{timedisplayk(lesson.started_at)}からの授業を中止にします。ご了承の程お願いします"
       link = "lessons/weeklyschedule"
       @link = @url + link
       User.sendmail_all_users( title, content, @link )
       flash[:warning] = "中止及び全員にメール送信しました。"
      else
       flash[:success] = "授業を再開しました。"
      end 
    else
      flash[:danger] = "登録に失敗しました"
    end
    redirect_to request.referrer
  end

  def destroy
    lesson = Lesson.find(params[:id])
    if lesson.destroy
      flash[:success] = "削除しました。"
    else
      flash[:danger]  = "削除に失敗しました。"
    end
    redirect_to "/lessons/weeklyschedule"
  end
  
  def attendance_processing
    reservation = Reservation.find(params[:id])
    reservation.absence = true
    if reservation.save
      flash[:success] = "該当受講生の欠席登録しました。"
    else
      flash[:danger]  = "該当受講生の欠席登録に失敗しました。"
    end
    redirect_to request.referrer
  end
  
  private
  
  def lesson_params
     params.require(:lesson).permit(:meeting_on, :target,:examineekanji,:starttime,:finishtime,:seats_real,:seats_zoom,:autoregister,:regularkanji,:note,:fixtimeres,:registrations,:registration_check)
  end
  def set_lesson
    @hourselect=timeselect(10,23)
    @capacity=[*0..30]
    @regular=["定例","臨時"]
    @target=["小学生","中高生","小中高生"]
  end
  def duplication_check
    starttimec = @lesson.started_at
    finishtimec = @lesson.finished_at
    meeting_on = @lesson.meeting_on
    #@reservecount = 0
    count = 0
    lasttime = (finishtimec-starttimec) / 1800
    if starttimec >= finishtimec
      @reservecounttotal = 1
    else
      while starttimec <= finishtimec
        #一回目のスタートタイムが前の授業の終わりと一緒でも登録必要にてそのまま通す
        if Lesson.where("finished_at =? AND meeting_on = ?" ,starttimec, meeting_on).where.not(id: @lesson_id).count >0 and count >=1 
          @reservecount = 1
        elsif Lesson.where("started_at =? AND meeting_on = ?" ,starttimec, meeting_on).where.not(id: @lesson_id).count >0 and count <lasttime
          @reservecount = 1
        end  
        starttimec = starttimec + 1800
        @reservecounttotal = @reservecounttotal + @reservecount
        @reservecount = 0
        count = count + 1
      end
    end
  end
end
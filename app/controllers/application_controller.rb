class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'date'
  include SessionsHelper
  #時間修正値9時間（秒）
  TIMECOL = 32400


  #学校を配列に
  def schoolgrade
     @grade= ["小学生", "中学生","小中高生"]
  end
  #管理者でなければログイン画面に推移する
  def  unlessadmintransition
      if current_user.present?
        redirect_to "/login" if current_user.admin==false
      end
  end
  
   # システム管理権限所有か判定.
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def set_user
    @user = User.find(params[:id])
  end
   # ログイン状態を判定して、してなければログイン画面に推移
  def unless_login
    redirect_to "/login" if current_user.blank?
  end
  
  def unless_login_lessondetail
    if params[:lesson_id].present?
      @lesson_id = params[:lesson_id]
      @student_id = params[:student_id]
    elsif  params[:reservation_id].present?
      @lesson_id = Reservation.find(params[:reservation_id].to_i).lesson_id
    else
      flash[:warning] = "該当の授業がありません"
    end
    if current_user.blank? and @lesson_id.present? and @lesson_id.present?
      redirect_to "/login?lesson_id=#{@lesson_id}&student_id=#{@student_id}"
    elsif current_user.blank?
      redirect_to "/login" 
    end
  end
  
  #保護者でログインした時に情報がなければ一番目の子供情報を取得
  def set_student
    @students=Student.where(user_id:current_user).where(withdrawal:nil)
    if session[:student_id].blank? && @students.present?
      @student=@students.first
      session[:student_id]=@student.id
    end
  end
  
  # 選択した生徒をインスタンス化する
  def select_student
    @student = Student.find(params[:id])
  end
  
  #保護者が他の家庭の生徒に保護者にアクセスしようとしたらログアウトする
  def unless_student
    @student = Student.find(params[:student_id])
    if @student.user_id != current_user.id and current_user.admin == false
        session[:student_id] = nil
        flash[:warning] = "再ログインをお願いします"
        log_out
        redirect_to '/login'
    end 
  end
  
  def weekday
    @weekday = ["月","火","水","木","金","土","日"]
  end

  def day_setting
    nowtime = Time.new + TIMECOL
    @today = nowtime.to_date
  end
  
  def mail_link_host
    protocol = request.protocol
    host = request.host
    @url = "#{ protocol }#{ host }/" #現在のurlを取得
  end
  
  def fix_check
    @studentcheck = Student.new(student_params)
      @fix_check = 0
      if ( @studentcheck.fix_day2 != "" and @studentcheck.fix_time2 == nil ) or ( @studentcheck.fix_day2 == "" and @studentcheck.fix_time2 != nil )
        @fix_check = 1
      elsif ( @studentcheck.fix_day3 != "" and @studentcheck.fix_time3 == nil ) or ( @studentcheck.fix_day3 == "" and @studentcheck.fix_time3 != nil )
       @fix_check = 1
      elsif ( @studentcheck.fix_day4 != "" and @studentcheck.fix_time4 == nil ) or ( @studentcheck.fix_day4 == "" and @studentcheck.fix_time4 != nil )
       @fix_check = 1
      end
  end
end

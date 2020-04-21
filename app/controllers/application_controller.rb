class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  #時間修正値9時間（秒）
  TIMECOL = 32400
  

  #学校を配列に
  def schoolgrade
     @grade= ["小学生", "中学生","小中学生"]
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
  
  #保護者でログインした時に情報がなければ一番目の子供情報を取得
  def set_student
    @students=Student.where(user_id:current_user).where(withdrawal:nil)
    if session[:student_id].blank? && @students.present?
      @student=@students.first
      session[:student_id]=@student.id
    end
  end
  #保護者が他の家庭の生徒に保護者にアクセスしようとしたらログアウトする
  def unless_student
    @student = Student.find(params[:student_id])
    if @student.user_id != current_user.id and current_user.admin == false
        session[:student_id] = nil
        flash[:warning] = "不正なアクセスがありました。ログインし直して下さい。"
        log_out
        redirect_to '/login'
    end 
  end
  def weekday
    @weekday = ["月","火","水","木","金","土"]
  end
end

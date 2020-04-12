class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

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
  
  #保護者でログインした時に子供情報を取得
  def set_student
    @students=Student.where(user_id:current_user)
    if session[:student_id].blank? && @students.present?
      @student=@students.first
      session[:student_id]=@student.id
    #else
      #@student=Student.find_by(id:@student_id)
      #session[:student]=@student
    end
  end
  
    # 選択した生徒をインスタンス化する
  def select_student
    @student = Student.find(params[:id])
  end
end

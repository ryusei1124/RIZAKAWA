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
  
  #保護者でログインした時に子供情報を取得
  def set_student
    @students=Student.where(user_id:current_user)
    if @student.blank?
      @student=@students.first
    else
      @student=Student.find_by(id:@student_id)
    end
  end
  
end

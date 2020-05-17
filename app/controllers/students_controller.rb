class StudentsController < ApplicationController
  before_action :select_student, only: [:info_edit, :update_basic_info, :info_update]
  before_action :logged_in_user, only: [:show, :info_edit, :info_update]
  
  def show
    @students = Student.all
  end
  
  def info_edit
  end
  
  def info_update
    if @student.update_attributes(student_params)
      flash[:success] = "#{@student.student_name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@student.student_name}の更新は失敗しました。<br>" + @student.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def create
     students = Student.create(student_params)
     if students.save
       flash[:success] = "基本情報を登録しました。"
     else
      flash[:danger] = "登録に失敗しました。"
    end
    redirect_to users_url
  end
  
  private

    def student_params
      params.require(:student).permit(:student_name, :user_id, :studentkana,  :zoom, :examinee, :school,  :birthday, :fix_day, :fix_time, :fix_day2, :fix_time2, :fix_day3, :fix_time3, :note, :withdrawal)
    end
    
  # beforeフィルター
  
  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
end

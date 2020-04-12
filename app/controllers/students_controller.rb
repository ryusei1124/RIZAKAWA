class StudentsController < ApplicationController
  before_action :select_student, only: [:info_edit, :update_basic_info]
  before_action :logged_in_user, only: [:show, :info_edit]
  
  def show
    @students = Student.all
  end
  
  def info_edit
  end
  
  def info_update
    if @student.update_attribute(info_edit_params)
      flash[:success] = "#{@student.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@student.name}の更新は失敗しました。<br>" + @student.errors.full_messages.join("<br>")
    end
    redirect_to users_url
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

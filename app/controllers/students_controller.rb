class StudentsController < ApplicationController
  before_action :select_student, only: [:info_edit, :update_basic_info, :info_update]
  before_action :logged_in_user, only: [:show, :info_edit, :info_update]
  before_action :day_setting, only: [:info_update]
  before_action :mail_link_host,   only: [:create]
  
  def show
    @students = Student.all
  end
  
  def info_edit
  end
  
  def info_update
    if @student.update_attributes(student_params)
      user = User.find( @student.user_id )
      students = Student.where(user_id:@student.user_id)
      if students.where(withdrawal:nil).blank? and students.present?
        user.withdrawal = students.maximum(:withdrawal)
      else
        user.withdrawal = nil
      end
      user.save
      flash[:success] = "#{@student.student_name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@student.student_name}の更新は失敗しました。<br>" + @student.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def create
     @student = Student.create(student_params)
     if @student.save
       @title = "受講者を登録しました。トップページの 基本情報(確認用）を確認願います。"
       @content = "下記リンクの確認をお願いします。"
       send_mail_address
       flash[:success] = "登録して対象者にメールを送信しました"
     else
       flash[:danger] = "登録に失敗しました。"
    end
    redirect_to users_url
  end

  def destroy
    student = Student.find(params[:id])
    questions = Question.where("student_id =?" ,student.id)
    questions.each do |quetion|
      quetion.destroy
    end
    if student.destroy and questions.blank?
      flash[:success] = "データを削除しました。"
    else
      flash[:danger] = "データを削除に失敗しました。"
    end
    redirect_to users_url
  end
  
  private

    def student_params
      params.require(:student).permit(:student_name, :user_id, :studentkana,  :zoom, :examinee, :school,  :birthday, :fix_day, :fix_time, :fix_day2, :fix_time2, :fix_day3, :fix_time3, :note, :withdrawal)
    end
  
  # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

  def send_mail_address
    @destination_user = User.find( @student.user_id )
    @bcc = current_user.email
    @send_user =  current_user
    link = "notices"
    @link = @url + link
    UserMailer.send_mail( @destination_user, @send_user, @bcc, @title, @content,@link).deliver_now
  end
end

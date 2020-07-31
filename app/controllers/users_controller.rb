class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :index]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :weekday, only: [:index]
  before_action :day_setting, only: [:index]
  include ApplicationHelper
  
  def index
    @users = User.user_kanaorder.undercontract
    #@admins = User.where(admin:true)
    #@weekday = ["月","火","水","木","金","土","日"]
    if params[:cation] == "2"
      @users = User.maneger_kana_order
      @students = Student.all
    elsif params[:cation] == "3"
      @users = User.order(id: "DESC")
      @students = Student.all
    else
      @users = User.undercontract.user_kanaorder
      @students = Student.under_contact
    end
    #固定時間一覧表作成
    @students_undercontact = Student.under_contact
    @students2= Student.under_contact.order(fix_day:"ASC")
    @student_ls = Array.new()
    #week_number = 0
    (0..6).each do |week_number|
      week_day = @weekday[week_number]
      fixtime = @first_time.to_time-TIMECOL
      while fixtime <= @last_time do
	     students_times= @students2.where("fix_time = ? and fix_day = ? ",fixtime,week_day)
            .or( @students2.where("fix_time2 = ? and fix_day2 = ? ",fixtime,week_day))
            .or( @students2.where("fix_time3 = ? and fix_day3 = ? ",fixtime,week_day))
            .or( @students2.where("fix_time4 = ? and fix_day4 = ? ",fixtime,week_day))
            .or( @students2.where("fix_time5 = ? and fix_day5 = ? ",fixtime,week_day))
        if students_times.count > 0
          students_times.each do |st|
            if st.fix_day==week_day and st.fix_time == fixtime
              time =  timedisplay(st.fix_time)
              finishtime =  timedisplay(st.fix_finishtime)
              examinee = ""
              zoom = ""
              examinee = " 受験生" if st.examinee?
              zoom = " Zoom" if st.zoom?
              student_name = st.student_name + " (" + Student.gradeyear( st.id ) + examinee + zoom + ")" 
              @student_ls.push([st.fix_day,time, student_name,finishtime])
            elsif st.fix_day2==week_day and st.fix_time2 == fixtime
              time =  timedisplay(st.fix_time2)
              finishtime =  timedisplay(st.fix_finishtime2)
              examinee = ""
              zoom = ""
              examinee = " 受験生" if st.examinee?
              zoom = " Zoom" if st.zoom?
              student_name = st.student_name + " (" + Student.gradeyear( st.id ) + examinee + zoom + ")" 
              @student_ls.push([st.fix_day2,time, student_name,finishtime])
            elsif st.fix_day3==week_day and st.fix_time3 == fixtime
              time =  timedisplay(st.fix_time3)
              finishtime =  timedisplay(st.fix_finishtime3)
              examinee = ""
              zoom = ""
              examinee = " 受験生" if st.examinee?
              zoom = " Zoom" if st.zoom?
              student_name = st.student_name + " (" + Student.gradeyear( st.id ) + examinee + zoom + ")" 
              @student_ls.push([st.fix_day3,time, student_name,finishtime])
            elsif st.fix_day4==week_day and st.fix_time4 == fixtime
              time =  timedisplay(st.fix_time4)
              finishtime =  timedisplay(st.fix_finishtime4)
              examinee = ""
              zoom = ""
              examinee = " 受験生" if st.examinee?
              zoom = " Zoom" if st.zoom?
              student_name = st.student_name + " (" + Student.gradeyear( st.id ) + examinee + zoom + ")" 
              @student_ls.push([st.fix_day4,time, student_name,finishtime])
            elsif st.fix_day5==week_day and st.fix_time5 == fixtime
              time =  timedisplay(st.fix_time5)
              finishtime =  timedisplay(st.fix_finishtime5)
              examinee = ""
              zoom = ""
              examinee = " 受験生" if st.examinee?
              zoom = " Zoom" if st.zoom?
              student_name = st.student_name + " (" + Student.gradeyear( st.id ) + examinee + zoom + ")" 
              @student_ls.push([st.fix_day5,time, student_name,finishtime])
            end
          end
        end
	      fixtime = fixtime + 1800
	   end
	  #week_number = week_number +1 
    end
    
  end
   
   
  def new
    @user = User.new
    @student = Student.new
  end
  
  def show
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。確認をお願いします。'
      redirect_to '/users?cation=3'
    else
      render :new
    end
  end
  def edit
    
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "情報を更新しました。"
      redirect_to '/users'
    else
      render :edit      
    end
    @user = User.find(params[:id])
  end
  
  def destroy
    if @user.destroy
      flash[:success] = "#{@user.guardian}のデータを削除しました。"
    else
      flash[:danger] = "#{@user.guardian}のデータ削除に失敗しました。"
    end
    redirect_to users_url
  end
  
  def edit_basic_info
    
  end
  
  def update_basic_info
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.guardian}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.guardian}の更新は失敗しました。メールアドレスの重複等確認願います。" 
    end
    redirect_to users_url
  end
  
  def login_page
  end
  
  private
    def user_params
      params.require(:user).permit(:guardian, :guardiankana,:student, :email,  :password, :password_confirmation, :withdrawal, :admin)
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
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      if current_user.admin == false
        redirect_to(root_url) unless current_user?(@user)
      end
    end
end

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :index]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :weekday, only: [:index]
  before_action :day_setting, only: [:index]
  include ApplicationHelper
  
  def index
    @admins = User.where(admin:true)
    @weekday = ["月","火","水","木","金","土","日"]
    if params[:cation] == "2"
      @users = User.where(admin:false).maneger_kana_order.paginate(page: params[:page], per_page: 40)
      @students = Student.all
    elsif params[:cation] == "3"
      @users = User.where(admin:false).order(id: "DESC").paginate(page: params[:page], per_page: 20)
      @students = Student.all
    else
      @user = User.undercontract.where(admin:false).user_kanaorder
      @users = @user.paginate(page: params[:page], per_page: 40)
      @students = Student.under_contact
    end
    @students_undercontact = Student.under_contact
    @student_ls = Array.new()
      @students_undercontact.each do | st |
        num = @weekday.index(st.fix_day).to_i
        time =  timedisplay(st.fix_time)
        ids = (num+1)*10000 + (st.fix_time.hour.to_i)*100 + st.fix_time.min.to_i
        student_name = st.student_name + " (" + Student.gradeyear( st.id ) + ")" 
        @student_ls.push([ids,st.fix_day,time, student_name])
        if st.fix_day2.present?  
          num = @weekday.index(st.fix_day2).to_i
          time = timedisplay(st.fix_time2)
          ids = (num+1)*10000 + (st.fix_time2.hour.to_i)*100 + st.fix_time2.min.to_i
          @student_ls.push([ids,st.fix_day2,time, student_name])
        elsif st.fix_day3.present?  
          num = @weekday.index(st.fix_day3).to_i
          time =  timedisplay(st.fix_time3)
          ids = (num+1)*10000 + (st.fix_time3.hour.to_i)*100 + st.fix_time3.min.to_i
          @student_ls.push([ids,st.fix_day3,time, student_name])
        end
      end
      @student_ls = @student_ls.sort
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

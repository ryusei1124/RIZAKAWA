class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
    @students=Student.all
  end
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.student}のデータを削除しました。"
    redirect_to users_url
  end

  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
    @user = User.find(params[:id])

  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.student}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
  end
  
  def login_page
  end
  
  private

    def user_params
      params.require(:user).permit(:guardian, :student, :email, :birthday, :school, :school_year, :zoom, :real, :fix_day, :fix_time, :password, :password_confirmation)
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
      redirect_to(root_url) unless current_user?(@user)
    end
end

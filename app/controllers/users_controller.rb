class UsersController < ApplicationController
  before_action :set_user, only: %i(destroy)
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.student}のデータを削除しました。"
    redirect_to users_url
  end
  
  def login_page
  end
  
  private

    def user_params
      params.require(:user).permit(:guardian, :student, :email, :sex, :school, :school_year, :zoom, :real, :fix_day, :fix_time, :password, :password_confirmation)
    end
end

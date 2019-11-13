class UsersController < ApplicationController
  
  def index
    @users = User.all
    @users = User.paginate(page: params[:page], per_page: 2)
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
  
  def login_page
  end
  
  private

    def user_params
      params.require(:user).permit(:guardian, :student, :email, :sex, :school, :school_year, :zoom, :real, :fix_day, :fix_time, :password, :password_confirmation)
    end
end

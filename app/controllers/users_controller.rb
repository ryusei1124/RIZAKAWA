class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :index]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :weekday, only: [:index]
  
  def index
    @admins = User.where(admin:true)
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
    @weekday = ["月","火","水","木","金","土","日"]
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


  def destroy
    @user.destroy
    flash[:success] = "#{@user.student}のデータを削除しました。"
    redirect_to users_url
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
    @user.destroy
    flash[:success] = "#{@user.student}のデータを削除しました。"
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

class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.undercontract
    user = user.find_by(email: params[:session][:email].downcase)
    session[:student_id]= nil if session[:student_id].present?
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to notices_path
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    log_out
    session[:student_id]= nil if session[:student_id].present?
    flash[:success] = "ログアウトしました"
    redirect_to root_url
  end
  
  def admin_login
     user = User.find(1)
    if user
      log_in user
      flash[:success] = '管理者でログインしました。'
      redirect_back_or notices_url
    else
     flash.now[:danger] = '認証に失敗しました。'  
     render :new
    end
  end
  
  def student_login
    user = User.find(2)
    if user
      log_in user
      flash[:success] = '生徒でログインしました。'
      redirect_back_or notices_url
    else
     flash.now[:danger] = '認証に失敗しました。'  
     render :new
    end
  end
end

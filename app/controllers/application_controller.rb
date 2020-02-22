class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # システム管理権限所有か判定.
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end

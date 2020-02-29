class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  #学校を配列に
  def schoolgrade
     @grade= ["小学生", "中学生","小中学生"]
  end
  #管理者でなければログイン画面に推移する
  def  unlessadmintransition
      if current_user.present?
        redirect_to "/login" if current_user.admin==false
      end
  end
end

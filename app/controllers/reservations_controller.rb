class ReservationsController < ApplicationController
  include ApplicationHelper
  before_action:unless_login
  require 'date'
  
  def index
  
  end
  
  def update
    @attencande_time = Reservation.find(params[:id])
    
    if @attendance_time.new(attendance_time: Time.current)
      flash[:success] = "出席時間を登録しました。"
    else
      flash[:danger] = "出席時間の登録に失敗しました。"
    end
    redirect_to lesson_detail_lesson_url
  end
  
  def reservations_log
    @user = User.find_by(params[:id])
  end
end
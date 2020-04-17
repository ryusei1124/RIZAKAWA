class ReservationsController < ApplicationController
  include ApplicationHelper
  before_action:unless_login
  require 'date'
  
  UPDATE_ERROR_MSG = "出席時間の登録に失敗しました。"
  
  def index
  end
  
  def update
    @reservation = Reservation.find(params[:id])
    
    if @reservation.attendance_time.nil?
      if @reservation.update_attributes(attendance_time: Time.current.change(sec: 0))
        flash[:success] = "出席時間を登録しました。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @reservation.leave_time.nil?
      if @reservation.update_attributes(leave_time: Time.current.change(see: 0))
        flash[:success] = "退席時間を登録しました。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
      redirect_to request.referrer
    end
  end
  
  def aaaa
    if @reservation.absence.nil?
      
      if @reservation.attributes = { absence: true }
        flash[:success] = "該当受講生の欠席登録しました。"
      else
        flash[:danger]  = "該当受講生の欠席登録に失敗しました。"
      end
    end
     redirect_to request.referrer
  end
      
  def destroy
    @reservation = Reservation.find(params[:id])
    
    @reservation.destroy
    flash[:success] = "出席時間と退席時間を削除しました。"
    
    redirect_to request.referrer
  end
  
  def reservations_log
    @user = User.find_by(params[:id])
  end
end
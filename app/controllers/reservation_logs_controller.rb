class ReservationLogsController < ApplicationController
  before_action :unless_login
  require 'date'

  def index
    if params[:cation] == "1"
      @day = params[:changeday].to_date
    else
      @day = Date.today
    end
    if current_user.admin?
      @reservation_logs = Reservation.log_order.where("meeting_on >= ? and meeting_on <= ?", @day.beginning_of_month, @day.end_of_month)
    else
      @reservation_logs = Reservation.log_order.where("meeting_on >= ? and meeting_on <= ?", @day.beginning_of_month, @day.end_of_month).where(user_id: current_user.id) 
    end
  end
end

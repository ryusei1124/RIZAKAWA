class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :student

  def self.log_order
    includes(:lesson).order("lessons.meeting_on DESC").order("lessons.started_at DESC")
  end
end

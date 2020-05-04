class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :student
  
  default_scope -> { order(fix_time: :asc) }

  def self.log_order
    includes(:lesson).order("lessons.meeting_on DESC").order("lessons.started_at DESC")
  end
end

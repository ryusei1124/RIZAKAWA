class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :student
  scope :fix_time_order , -> { order(fix_time: :asc) }
  scope :cancel_exclusion, -> { where(cancel: false) }
  scope :cancel_only, -> { where(cancel: true) }

  def self.log_order
    includes(:lesson).order("lessons.meeting_on DESC").order("lessons.started_at DESC")
  end
end

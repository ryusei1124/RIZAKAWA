class Reservation < ApplicationRecord
  belongs_to :student
  belongs_to :user
  belongs_to :lesson
  
  validate :leave_time_is_invalid_without_a_attendance_time
  
  def leave_time_is_invalid_without_a_attendance_time
    errors.add(:attendance_time, "が必要です。") if attendance_time.blank? && leave_time.present?
  end
end

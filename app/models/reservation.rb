class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
<<<<<<< HEAD
  
  validate :leave_time_is_invalid_without_a_attendance_time
  
  def leave_time_is_invalid_without_a_attendance_time
    errors.add(:attendance_time, "が必要です。") if attendance_time.blank? && leave_time.present?
  end
=======
  belongs_to :student
>>>>>>> 60781f4b5edc0fd918c447eda3d57b087d9301fa
end

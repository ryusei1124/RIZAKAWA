class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :student
end

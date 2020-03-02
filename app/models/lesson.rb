class Lesson < ApplicationRecord
  has_many :reservations, dependent: :destroy
  attr_accessor :regularkanji
  attr_accessor :starttime
  attr_accessor :finishtime
end

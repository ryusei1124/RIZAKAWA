class Lesson < ApplicationRecord

  belongs_to :user
  has_many :reservations, dependent: :destroy
  attr_accessor :regularkanji
  attr_accessor :starttime
  attr_accessor :finishtime
end

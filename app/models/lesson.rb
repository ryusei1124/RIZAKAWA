class Lesson < ApplicationRecord
  belongs_to :user
  has_many :lessoncomments, dependent: :destroy
  has_many :reservations, dependent: :destroy
  attr_accessor :regularkanji
  attr_accessor :examineekanji
  attr_accessor :starttime
  attr_accessor :finishtime
  attr_accessor :autoregister
  attr_accessor :fixtimeres
  attr_accessor :registration_check
  attr_accessor :registrations
end

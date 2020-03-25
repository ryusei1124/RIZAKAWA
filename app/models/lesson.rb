class Lesson < ApplicationRecord

  belongs_to :user
  has_many :reservations, dependent: :destroy
  attr_accessor :regularkanji
  attr_accessor:examineekanji
  attr_accessor :starttime
  attr_accessor :finishtime
  attr_accessor :autoregister
end

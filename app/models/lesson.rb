class Lesson < ApplicationRecord
  belongs_to :user
  attr_accessor :regularkanji
  attr_accessor :starttime
  attr_accessor :finishtime
end

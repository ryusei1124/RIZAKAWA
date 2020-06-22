class Lessoncomment < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  belongs_to :student
  validates :content, presence: true
end
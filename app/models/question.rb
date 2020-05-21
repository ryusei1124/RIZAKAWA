class Question < ApplicationRecord
  belongs_to :user
  belongs_to :student
  has_many :answers, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  
  validates :question_content, presence: true
  validates :question_title, presence: true
end

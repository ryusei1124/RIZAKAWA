class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  # belongs_to :student
  default_scope -> { order(created_at: :desc) }
  
  validates :answer_content, presence: true
end

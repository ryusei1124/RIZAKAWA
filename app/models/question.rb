class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  scope :created_at_order, -> { order(created_at: :desc) }
  
  validates :question_content, presence: true
  validates :question_title, presence: true
end

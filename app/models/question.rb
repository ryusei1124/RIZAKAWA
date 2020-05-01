class Question < ApplicationRecord
  belongs_to :user
  belongs_to :student
  has_many :answers, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
end

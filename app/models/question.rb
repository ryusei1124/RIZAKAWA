class Question < ApplicationRecord
  belongs_to :user
  belongs_to :student
  default_scope -> { order(updated_at: :desc) }
end

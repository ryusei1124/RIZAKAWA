class Question < ApplicationRecord
  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
end

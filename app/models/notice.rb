class Notice < ApplicationRecord
  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
  validates :notice_title,  presence: true
  validates :notice_content, presence: true
end

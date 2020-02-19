class Notice < ApplicationRecord
    validates :notice_title,  presence: true
    validates :notice_content, presence: true
end

class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :guardian,  presence: true, length: { maximum: 50 }
  validates :student,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :sex, presence: true
  validates :school, presence: true
  validates :school_year, presence: true
  validates :fix_day, presence: true
  validates :fix_time, presence: true
end

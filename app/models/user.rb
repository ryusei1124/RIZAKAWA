class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :notices
  
  # 生徒一覧の名前順
  default_scope -> { order(student: :asc) }
  
  before_save { self.email = email.downcase }

  validates :guardian,  presence: true, length: { maximum: 50 }
  validates :student,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :school, presence: true
  # validates :school_year, presence: true
  validates :birthday, presence: true
  validates :fix_day, presence: true
  validates :fix_time, presence: true
  validates :birthday, presence: true
  
  validate :class_hoice
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def class_hoice
    errors.add(:class_choice, "はどちらか一つ選択してください") if zoom.present? && real.present?
  end
  
end

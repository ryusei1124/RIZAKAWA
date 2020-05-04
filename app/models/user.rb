class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token
  has_many :notices, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :lessoncomments, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  
  # 生徒一覧の名前順
  default_scope -> { order(student: :asc) }
  
  before_save { self.email = email.downcase }

  validates :guardian, length: { maximum: 50 }
  validates :student, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  validate :class_hoice
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
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
  
  #スコープ契約中の保護者一覧
  def self.undercontract
    joins(:students).where(withdrawal:nil).group("users.id").order(guardiankana: "ASC")
  end
  #契約先全員へのメール
  def self.sendmail_all_users(  title, content, link )
    undercontracts = self.undercontract
    @send_user = find(1)
    @title = title
    @content = content
    @link = link
    #契約中のユーザー全員にメールを送る
    undercontracts.each do | user |
      @destination_user = find(user.id)
      UserMailer.send_mail( @destination_user, @send_user, @title, @content, @link ).deliver_now
    end
    #ユーザーに何を送ったかわかるように管理者にも送る。今はひとりだが将来も考え管理者全員に送る。
    admins = where("admin = ?", true )
    admins.each do | user |
      @destination_user = find(user.id)
      UserMailer.send_mail( @destination_user, @send_user, @title, @content, @link ).deliver_now
    end
  end
  
  def feed
    Question.where("user_id = ?", id)
  end
  

end

class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :lessons, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 128}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, presence: true, allow_nil: true
  before_save {email.downcase!}

  scope :order_by_name, ->{order :name}
  scope :search_name_or_email, ->q do
    where "name LIKE ? OR email LIKE ?", "%#{q}%", "%#{q}%" if q.present?
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password? remember_token
  end

  def admin?
    self.is_admin?
  end

  def avatar_path
    self.avatar? ? self.avatar.url : Settings.avatar_default
  end

  def is_user? user
    self == user
  end
end

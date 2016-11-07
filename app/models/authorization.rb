class Authorization < ApplicationRecord
  belongs_to :user
  validates :provider, presence: true
  validates :uid, presence: true

  class << self
    def sign_in_from_omniauth auth
      authorization = find_by provider: auth[:provider], uid: auth[:uid]
      return nil unless authorization
      User.find_by_id authorization.user_id
    end

    def find_user_by_email auth
      User.find_by email: auth[:info][:email]
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:github]

  validates :full_name, :username, :email, :presence => true
  validates :username, :email,  :uniqueness => true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates_length_of :username, within: 5..20, too_long: 'pick a shorter username', too_short: 'pick a longer username'
  validates_length_of :short_bio, within: 0..200, too_long: 'You can not use more than 200 characters'
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  has_one :gplus_link, dependent: :destroy
  has_one :facebook_link, dependent: :destroy
  has_one :website_link, dependent: :destroy
  has_one :twitter_link, dependent: :destroy
  has_one :blog_link, dependent: :destroy
  has_one :quora_link, dependent: :destroy

  has_one :codeforces_profile, dependent: :destroy
  has_one :github_profile, dependent: :destroy
  has_one :topcoder_profile, dependent: :destroy

  has_many :mail_notifications, :foreign_key => "receiver_id"
  has_many :notifications, through: :mail_notifications, :class_name => "MailNotification", :foreign_key => "mail_notifications_id"

  def self.from_omniauth(auth, current_user)
    case auth[:provider]
    when "github"
      authorization = GithubProfile.where(:user_id => current_user.id).first
      if authorization.nil?
        authorization = GithubProfile.create(:username => auth[:info][:nickname], :user_id => current_user.id)
      end
      authorization
    end
  end
end

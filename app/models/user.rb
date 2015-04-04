class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:github, :linkedin]

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
  has_one :linkedin_profile, dependent: :destroy

  belongs_to :location

  has_many :mail_notifications, :foreign_key => "receiver_id"
  has_many :notifications, through: :mail_notifications, :class_name => "MailNotification", :foreign_key => "mail_notifications_id"

  has_and_belongs_to_many :languages, dependent: :destroy

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

  def self.create_linkedin(auth, current_user)
    authorization = LinkedinProfile.where(:user_id => current_user.id).first
    if authorization.nil?
      authorization = LinkedinProfile.create(:user_id => current_user.id, :uid => auth["uid"], :token => auth["credentials"].token, :secret => auth["credentials"].secret)
    end
    authorization
  end

  def skills
    skills = []
    skills << self.linkedin_profile.data["skills"] unless self.linkedin_profile.nil?
    skills << self.codeforces_profile.metadata["tags"].keys unless self.codeforces_profile.nil?
    skills.flatten!
  end

  def self.all_skills
    skills = []
    LinkedinProfile.all.each do |li|
      skills << li.data["skills"]
    end
    CodeforcesProfile.all.each do |cf|
      skills << cf.metadata["tags"].keys
    end
    skills.flatten!
    skills.uniq!
    skills
  end
end

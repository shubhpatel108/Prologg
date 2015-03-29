class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:github, :linkedin]

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
end

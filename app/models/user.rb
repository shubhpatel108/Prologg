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
  attr_readonly :username

  has_one :gplus_link, dependent: :destroy
  has_one :facebook_link, dependent: :destroy
  has_one :website_link, dependent: :destroy
  has_one :twitter_link, dependent: :destroy
  has_one :blog_link, dependent: :destroy
  has_one :quora_link, dependent: :destroy
  has_one :stack_link, dependent: :destroy

  has_one :codeforces_profile, dependent: :destroy
  has_one :github_profile, dependent: :destroy
  has_one :topcoder_profile, dependent: :destroy
  has_one :linkedin_profile, dependent: :destroy

  belongs_to :location
  accepts_nested_attributes_for :location

  has_many :mail_notifications, :foreign_key => "receiver_id"
  has_many :notifications, through: :mail_notifications, :class_name => "MailNotification", :foreign_key => "mail_notifications_id"

  has_and_belongs_to_many :languages, dependent: :destroy

  def self.from_omniauth(auth, current_user)
    case auth[:provider]
    when "github"
      authorization = GithubProfile.where(:user_id => current_user.id).first
      if authorization.nil?
        authorization = GithubProfile.create(:username => auth[:info][:nickname], :user_id => current_user.id, :token => auth[:credentials].token)
        data = {}
        data.merge!(:followers_count => auth[:extra][:raw_info][:followers])
        data.merge!(:last_updated => auth[:extra][:raw_info][:updated_at])
        authorization.data = data
        authorization.data_will_change!
        authorization.save!
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

  def tags
    if codeforces_profile.nil?
      []
    else
      codeforces_profile.metadata["tags"].keys
    end
  end

  def linkedin_skills
    if linkedin_profile.nil?
      []
    else
      linkedin_profile.data["skills"]
    end
  end

  def skills
    skills = []
    skills << self.linkedin_skills
    skills << self.tags
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

  def application_langs
    langs_hash = {}

    github = self.github_profile
    unless github.nil?
      github_langs = github.data["repos"].map{|l| l["languages"]}.flatten
      list = github_langs.uniq

      list.each do |lang|
        langs_hash.merge!("#{lang}" =>github_langs.count(lang))
      end
    end

    return langs_hash.sort {|a,b| a[1]<=>b[1]}.reverse.to_h
  end

  def algo_langs
    langs_hash = {}

    cfp = self.codeforces_profile
    unless cfp.nil?
      codeforces_langs = cfp.metadata["languages"]
      langs_hash.merge!(codeforces_langs)
    end

    return langs_hash.sort {|a,b| a[1]<=>b[1]}.reverse.to_h
  end

  def all_langs(application_langs={}, algo_langs={})
    if application_langs.empty?
      langs_hash = self.application_langs
    else
      langs_hash = application_langs
    end

    if algo_langs.empty?
      algo_langs = self.algo_langs
    end

    algo_langs.each do |lang, count|
      if langs_hash.key?(lang)
        langs_hash[lang] = langs_hash[lang] + count
      else
        langs_hash.merge!("#{lang}" => count)
      end
    end
    return langs_hash.sort {|a,b| a[1]<=>b[1]}.reverse.to_h
  end

  def technical_integrations
    ints = []
    ints << "Github" unless self.github_profile.nil?
    ints << "Codeforces" unless self.codeforces_profile.nil?
    ints << "Topcoder" unless self.topcoder_profile.nil?
    return ints
  end

  def has_app_accounts
    return false if codeforces_profile.nil? and codeforces_profile.nil?
    return true
  end

end

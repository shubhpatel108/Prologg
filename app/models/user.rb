class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :gplus_link, dependent: :destroy
  has_one :facebook_link, dependent: :destroy
  has_one :website_link, dependent: :destroy
  has_one :twitter_link, dependent: :destroy
  has_one :blog_link, dependent: :destroy
end

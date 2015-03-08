class FacebookLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		url.gsub!("https://", "")
		url.gsub!("www.", "")
		url.gsub!("facebook.com/", "")
	end

	def nurl
		"https://www.facebook.com/" + self.url
	end

end

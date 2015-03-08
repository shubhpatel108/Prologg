class TwitterLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		url.gsub!("https://", "")
		url.gsub!("www.", "")
		url.gsub!("twitter.com/", "")
	end

	def nurl
		"https://www.twitter.com/" + self.url
	end

end

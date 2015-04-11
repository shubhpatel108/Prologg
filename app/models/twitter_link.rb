class TwitterLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		if url.nil? or url.empty?
			return ""
		else
			url.gsub!("https://", "")
			url.gsub!("www.", "")
			url.gsub!("twitter.com/", "")
		end
		return url
	end

	def nurl
		"https://www.twitter.com/" + self.url
	end

end

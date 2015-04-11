class QuoraLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		if url.nil? or url.empty?
			return ""
		else
			url.gsub!("https://", "")
			url.gsub!("www.", "")
			url.gsub!("quora.com/", "")
		end
		return url
	end

	def nurl
		"https://www.quora.com/" + self.url
	end
end

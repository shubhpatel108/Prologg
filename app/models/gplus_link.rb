class GplusLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		if url.nil? or url.empty?
			return ""
		else
			url.gsub!("https://", "")
			url.gsub!("www.", "")
			url.gsub!("plus.google.com/", "")
		end
		return url
	end

	def nurl
		"https://www.plus.google.com/" + self.url
	end

end

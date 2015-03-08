class GplusLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		url.gsub!("https://", "")
		url.gsub!("www.", "")
		url.gsub!("plus.google.com/", "")
	end

	def nurl
		"https://www.plus.google.com/" + self.url
	end

end

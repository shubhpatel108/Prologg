class StackLink < ActiveRecord::Base
	belongs_to :user

	def self.normalize_url(url)
		if url.nil? or url.empty?
			return ""
		else
			url.gsub!("http://", "")
			url.gsub!("www.", "")
			url.gsub!("stackoverflow.com/users/", "")
		end
	end

	def nurl
		"http://www.stackoverflow.com/users/" + self.url
	end
end

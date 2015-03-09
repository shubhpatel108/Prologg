class CodeforcesProfile < ActiveRecord::Base
	belongs_to :user

	def self.get(url)
		begin
			resp = RestClient.get(url)
			return JSON.parse(resp)
		rescue
			return {"status" => "bad_request"}
		end
	end

	def self.connect(handle)
		url = "http://codeforces.com/api/user.info?handles=#{handle}"
		resp = self.get(url)
		return [resp["status"], resp]
	end

	def self.get_submissions(handle)
		url = "http://codeforces.com/api/user.status?handle=#{handle}&from=1&count=1000"
		resp = self.get(url)
		return [resp["status"], resp]
	end

	def self.get_ratings(handle)
		url = "http://codeforces.com/api/user.rating?handle=#{handle}"
		resp = self.get(url)
		return [resp["status"], resp]
	end

	def self.get_recent_submissions(handle)
		url = "http://codeforces.com/api/user.status?handle=#{handle}&from=1&count=5"
		resp = self.get(url)
		return [resp["status"], resp]
	end
end

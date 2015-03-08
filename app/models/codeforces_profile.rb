class CodeforcesProfile < ActiveRecord::Base
	belongs_to :user

	def self.get(url)
		begin
			resp = RestClient.get(url)
			JSON.parse(resp)
		rescue
			return [{"status" => "bad_request"}, {}]
		end
	end

	def self.connect(handle)
		url = "http://codeforces.com/api/user.info?handles=#{handle}"
		resp = self.get(url)
		return [resp["status"], resp]
	end
end

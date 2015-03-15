class TopcoderProfile < ActiveRecord::Base
	belongs_to :user

	def self.get(url)
		begin
			resp = RestClient.get(url)
			logger.info("========1")
			resp = JSON.parse(resp)
			logger.info("========1")
			if resp.class.to_s == "Array"
			logger.info("========1")
				resp = {"result" => resp}
			end
			logger.info("========1")
			resp.merge!("status" => "OK")
			return resp
		rescue
			return {"status" => "bad_request"}
		end
	end

	def self.connect(handle)
		key = ENV['TC_KEY']
		url = "http://api.topcoder.com/rest/statistics/#{handle}?user_key=#{key}"
		resp = self.get(url)
		return resp
	end

	def self.get_achievements(handle)
		key = ENV['TC_KEY']
		url = "http://api.topcoder.com/rest/statistics/#{handle}/achievements?user_key=#{key}"
		resp = self.get(url)
		return resp
	end

end

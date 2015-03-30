class TopcoderProfile < ActiveRecord::Base
	belongs_to :user

	def self.get(url)
		begin
			resp = RestClient.get(url)
			resp = JSON.parse(resp)
			if resp.class.to_s == "Array"
				resp = {"result" => resp}
			end
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

	def self.refine_basic_info(response_info)
		response_info.delete("handle")
		response_info.delete("status")
		response_info.delete("country")
		response_info["ratingsSummary"].each do |rating|
			rating.delete("colorStyle")
		end
		response_info
	end

	def self.refine_achievements(response_achivs)
		achievements = response_achivs["result"]
		achievements.each do |a|
			a["badgeLink"].delete("url")
		end
		achievements
	end

end

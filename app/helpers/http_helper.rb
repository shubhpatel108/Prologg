module HttpHelper
	def get(url)
		begin
			resp = RestClient.get(url)
			return JSON.parse(resp)
		rescue
			return [{"status" => "bad_request"}, {}]
		end
	end
end

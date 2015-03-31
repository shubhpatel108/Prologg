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

	def self.problems_lang_tags(resp_subs)
		solved_probs = 0		#total number of problems solved
		langs = {}				#hash of hashes - languages => no of problems solved
		tags_count = {}			#hash of hashes - tags => total no. of problems in which it is found.
		resp_subs.select do |h|
			if h["verdict"]=="OK"
				if langs.key?(h["programmingLanguage"])
					langs.merge!(h["programmingLanguage"] => langs[h["programmingLanguage"].to_s] + 1)
				else
					langs.merge!(h["programmingLanguage"] => 1)
				end
				tags = h["problem"]["tags"]
				tags.each do |tag|
					if tags_count.key?(tag)
						tags_count.merge!(tag => tags_count[tag] + 1)
					else
						tags_count.merge!(tag => 1)
					end
				end
				solved_probs = solved_probs + 1
			end
		end

		tags_count = tags_count.to_a.sort_by {|tag| tag[1]}.reverse.to_h
		langs = langs.to_a.sort_by {|lang| lang[1]}.reverse.to_h

		return [solved_probs, tags_count, langs]
	end

	def self.ratings(resp_rates)
		resp_rates.each do |h|
			h.delete("contestId")
			h.delete("contestName")
			h.delete("rank")
		end
		resp_rates.slice!(resp_rates.length-4..resp_rates.length)
		resp_rates
	end
end

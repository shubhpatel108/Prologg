class CodeforcesProfileController < ApplicationController
	before_filter :authenticate_user!
	protect_from_forgery except: :recent_submissions

	def new
	end

	def create
		handle = params[:handle]

		response_info = CodeforcesProfile.connect(handle)
		status_info = response_info[0]
		resp_info = response_info[1]["result"][0]

		response_subs = CodeforcesProfile.get_submissions(handle)
		status_subs = response_subs[0]
		resp_subs = response_subs[1]["result"]

		response_rates = CodeforcesProfile.get_ratings(handle)
		status_rates = response_rates[0]
		resp_rates = response_rates[1]["result"]

		if status_info == "OK" and status_subs == "OK" and status_rates == "OK"
			@codeforces_profile = CodeforcesProfile.new(
				user_id: current_user.id,
				handle: resp_info["handle"],
				contribution: resp_info["contribution"],
				rank: resp_info["rank"],
				max_rank: resp_info["maxRank"],
				rating: resp_info["rating"],
				max_rating: resp_info["maxRating"],
				last_online: DateTime.strptime(resp_info["lastOnlineTimeSeconds"].to_s, '%s')
				)

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

			resp_rates.each do |h|
				h.delete("contestId")
				h.delete("contestName")
				h.delete("rank")
			end
			resp_rates.slice!(resp_rates.length-4..resp_rates.length)

			tags_count = tags_count.to_a.sort_by {|tag| tag[1]}.reverse.to_h
			langs = langs.to_a.sort_by {|lang| lang[1]}.reverse.to_h

			@codeforces_profile.metadata = { solved_probs: solved_probs, languages: langs, tags: tags_count, ratings: resp_rates }
			@codeforces_profile.save!

			flash[:notice] = "You have successfully integrated Codeforces in your profile."
			redirect_to profile_path(username: current_user.username)
		else
			flash[:alert] = "It seems your credentials are not authentic or something went wrong."
			redirect_to :back
		end
	end

	def recent_submissions
		handle = params[:handle]
		response = CodeforcesProfile.get_recent_submissions(handle)
		status = response[0]
		@resp = response[1]["result"].paginate(page: params[:page], per_page: 4 )

		if status=="OK"
			@resp.each do |sub|
				sub.select! {|k,v| ["problem", "programmingLanguage", "creationTimeSeconds", "verdict"].include?(k) }
				sub["problem"].select! {|k,v| ["name"].include?(k) }
			end
			respond_to do |format|
				format.js
			end
		else
			render js: ""
		end
	end
end

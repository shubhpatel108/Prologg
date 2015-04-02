class CodeforcesProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:new, :create, :update]
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

			data1 = CodeforcesProfile.problems_lang_tags(resp_subs)
			solved_probs = data1[0]			#total number of problems solved
			tags_count = data1[1]			#hash of hashes - tags => total no. of problems in which it is found.
			langs = data1[2]				#hash of hashes - languages => no of problems solved

			resp_rates = CodeforcesProfile.ratings(resp_rates)

			@codeforces_profile.metadata = { solved_probs: solved_probs, languages: langs, tags: tags_count, ratings: resp_rates }
			@codeforces_profile.save!

			flash[:notice] = "You have successfully integrated Codeforces in your profile."
			redirect_to profile_path(username: current_user.username)
		else
			flash[:alert] = "It seems your credentials are not authentic or something went wrong."
			redirect_to :back
		end
	end

	def update
		@codeforces_profile = current_user.codeforces_profile

		if @codeforces_profile.nil?
			flash[:alert] = "You don't have Codeforces account integrated with your profile."
			redirect_to :back
		else
			handle = @codeforces_profile.handle

			response_info = CodeforcesProfile.connect(handle)
			status_info = response_info[0]
			resp_info = response_info[1]["result"][0]

			if status_info == "OK"
				new_last_online = DateTime.strptime(resp_info["lastOnlineTimeSeconds"].to_s, '%s')

				if @codeforces_profile.last_online < new_last_online

					response_subs = CodeforcesProfile.get_submissions(handle)
					status_subs = response_subs[0]
					resp_subs = response_subs[1]["result"]

					response_rates = CodeforcesProfile.get_ratings(handle)
					status_rates = response_rates[0]
					resp_rates = response_rates[1]["result"]

					if status_subs == "OK" and status_rates == "OK"
						@codeforces_profile.update_attributes(
							contribution: resp_info["contribution"],
							rank: resp_info["rank"],
							max_rank: resp_info["maxRank"],
							rating: resp_info["rating"],
							max_rating: resp_info["maxRating"],
							last_online: new_last_online
						)

						data1 = CodeforcesProfile.problems_lang_tags(resp_subs)
						solved_probs = data1[0]			#total number of problems solved
						tags_count = data1[1]			#hash of hashes - tags => total no. of problems in which it is found.
						langs = data1[2]				#hash of hashes - languages => no of problems solved

						resp_rates = Codeforces.ratings(resp_rates)

						@codeforces_profile.metadata = { solved_probs: solved_probs, languages: langs, tags: tags_count, ratings: resp_rates }
						@codeforces_profile.metadata_will_change!
						@codeforces_profile.save!
						flash[:notice] = "Successfully updated your Codeforces profile!"
						redirect_to profile_path(username: current_user.username)
					else
						flash[:alert] = "It seems your credentials are not authentic or something went wrong."
						redirect_to :back
					end
				else
					flash[:notice] = "Your Codeforces profile is already upto date."
					redirect_to :back
				end
			else
				flash[:alert] = "It seems your credentials are not authentic or something went wrong."
				redirect_to :back
			end
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

	def show_cfp_profile
		@user = User.where(username: params[:username]).first
		@cfp = @user.codeforces_profile

		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end

		respond_to do |format|
			format.js
			format.html
		end
	end

	def delete
		unless current_user.codeforces_profile.nil?
			CodeforcesProfile.where(:user => current_user).first.destroy
	 		current_user.save!
	 		current_user.reload
	 	end
		respond_to do |format|
			format.js
		end	
	end

end

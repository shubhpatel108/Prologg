class CodeforcesProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:new, :create, :update]
	protect_from_forgery except: :recent_submissions

	def new
	end

	def create
		handle = params[:handle]

		begin
			response_info = CodeforcesProfile.connect(handle)
			status_info = response_info[0]

			if status_info == "OK"

				response_subs = CodeforcesProfile.get_submissions(handle)
				status_subs = response_subs[0]

				response_rates = CodeforcesProfile.get_ratings(handle)
				status_rates = response_rates[0]

				if status_subs == "OK" and status_rates == "OK"

					resp_info = response_info[1]["result"][0]
					resp_subs = response_subs[1]["result"]
					resp_rates = response_rates[1]["result"]

					@codeforces_profile = CodeforcesProfile.new(
						user_id: current_user.id,
						handle: resp_info["handle"]
					)

					data1 = CodeforcesProfile.problems_lang_tags(resp_subs)
					solved_probs = data1[0]			#total number of problems solved
					tags_count = data1[1]			#hash of hashes - tags => total no. of problems in which it is found.
					langs = data1[2]				#hash of hashes - languages => no of problems solved

					database_langs = Language.all.map(&:name)
					user_database_langs = current_user.languages.map(&:name)
					langs.keys.each do |lang|
						if database_langs.include?(lang)
							unless user_database_langs.include?(lang)
								existing_lang = Language.where(name: lang).first
								current_user.languages << existing_lang
							end
						else
							new_lang = Language.create(name: lang)
							current_user.languages << new_lang
						end
					end

					#Update Last updated at attribute
					current_user.profile_updated_at = Time.now
					current_user.save!
					current_user.reload

					resp_rates = CodeforcesProfile.ratings(resp_rates)

					resp_info["firstName"] = "" if resp_info["firstName"].nil?
					resp_info["lastName"] = "" if resp_info["lastName"].nil?

					@codeforces_profile.data = {
													solved_probs: solved_probs,
													languages: langs,
													tags: tags_count,
													ratings: resp_rates,
													handle: resp_info["handle"],
													contribution: resp_info["contribution"],
													rank: resp_info["rank"],
													max_rank: resp_info["maxRank"],
													rating: resp_info["rating"],
													max_rating: resp_info["maxRating"],
													last_online: DateTime.strptime(resp_info["lastOnlineTimeSeconds"].to_s, '%s'),
													real_name: [resp_info["firstName"], resp_info["lastName"]].join(" ")
												}
					@codeforces_profile.save!

					flash[:notice] = "You have successfully integrated Codeforces in your profile."
					redirect_to profile_path(username: current_user.username)
				else
					flash[:alert] = "It seems your credentials are not authentic or something went wrong."
					redirect_to :back
				end
			else
				flash[:alert] = "It seems your credentials are not authentic or something went wrong. Try again after sometime."
				redirect_to :back
			end
		rescue Exception => e
			cfp = current_user.codeforces_profile
			unless cfp.nil?
				cfp.destroy
			end
			current_user.reload
			flash[:alert] = "It seems your credentials are not authentic or something went wrong. Try again after sometime."
			redirect_to :back
		end
	end

	def update
		@codeforces_profile = current_user.codeforces_profile
		old_data = @codeforces_profile.data

		if @codeforces_profile.nil?
			flash[:alert] = "You don't have Codeforces account integrated with your profile."
			redirect_to :back
		else
			handle = @codeforces_profile.handle

			begin
				response_info = CodeforcesProfile.connect(handle)
				status_info = response_info[0]
				resp_info = response_info[1]["result"][0]

				if status_info == "OK"
					new_last_online = DateTime.strptime(resp_info["lastOnlineTimeSeconds"].to_s, '%s')

					if @codeforces_profile.data["last_online"] < new_last_online

						response_subs = CodeforcesProfile.get_submissions(handle)
						status_subs = response_subs[0]
						resp_subs = response_subs[1]["result"]

						response_rates = CodeforcesProfile.get_ratings(handle)
						status_rates = response_rates[0]
						resp_rates = response_rates[1]["result"]

						if status_subs == "OK" and status_rates == "OK"

							data1 = CodeforcesProfile.problems_lang_tags(resp_subs)
							solved_probs = data1[0]			#total number of problems solved
							tags_count = data1[1]			#hash of hashes - tags => total no. of problems in which it is found.
							langs = data1[2]				#hash of hashes - languages => no of problems solved

							database_langs = Language.all.map(&:name)
							user_database_langs = current_user.languages.map(&:name)
							langs.keys.each do |lang|
								if database_langs.include?(lang)
									unless user_database_langs.include?(lang)
										existing_lang = Language.where(name: lang).first
										current_user.languages << existing_lang
									end
								else
									new_lang = Language.create(name: lang)
									current_user.languages << new_lang
								end
							end

							#Update Last updated at attribute
							current_user.profile_updated_at = Time.now
							current_user.save!
							current_user.reload

							resp_rates = CodeforcesProfile.ratings(resp_rates)

							@codeforces_profile.data = {
													solved_probs: solved_probs,
													languages: langs,
													tags: tags_count,
													ratings: resp_rates,
													handle: resp_info["handle"],
													contribution: resp_info["contribution"],
													rank: resp_info["rank"],
													max_rank: resp_info["maxRank"],
													rating: resp_info["rating"],
													max_rating: resp_info["maxRating"],
													last_online: DateTime.strptime(resp_info["lastOnlineTimeSeconds"].to_s, '%s') 
												}
							@codeforces_profile.data_will_change!
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
			rescue Exception => e
				@codeforces_profile.data = old_data
				@codeforces_profile.data_will_change!
				@codeforces_profile.save!
				current_user.reload
				flash[:alert] = "It seems your credentials are not authentic or something went wrong."
				redirect_to :back
			end
		end
	end

	def recent_submissions
		handle = params[:handle]

		begin
			response = CodeforcesProfile.get_recent_submissions(handle)
			status = response[0]

			if status=="OK"
				@resp = response[1]["result"].paginate(page: params[:page], per_page: 4)
				@resp.each do |sub|
					sub.select! {|k,v| ["problem", "programmingLanguage", "creationTimeSeconds", "verdict"].include?(k) }
					sub["problem"].select! { |k,v| ["name"].include?(k) }
				end
				respond_to do |format|
					format.js
				end
			else
				render js: ""
			end
		rescue Exception => e
			render js: ""
		end
	end

	def show_cfp_profile
		@user = User.where(username: params[:username]).first
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		else
			@cfp = @user.codeforces_profile
			respond_to do |format|
				format.js
				format.html
			end
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

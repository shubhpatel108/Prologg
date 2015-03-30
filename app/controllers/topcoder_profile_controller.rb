class TopcoderProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:new, :create]

	def new
	end

	def create
		handle = params[:handle]

		response_info = TopcoderProfile.connect(handle)
		status_info = response_info["status"]

		if status_info=="OK"
			response_info = TopcoderProfile.refine_basic_info(response_info)

			@tpf = TopcoderProfile.create(user_id: current_user.id, handle: handle, data: response_info)

			response_achivs = TopcoderProfile.get_achievements(handle)
			status_achivs = response_achivs["status"]

			if status_achivs=="OK"
				data = @tpf.data
				achievements = TopcoderProfile.refine_achievements(response_achivs)
				data.merge!("achievements" => achievements)

				@tpf.data = data
				@tpf.data_will_change!
				@tpf.save!
			end

			flash[:notice] = "You have successfully integrated Codeforces in your profile."
			redirect_to profile_path(username: current_user.username)
		else
			flash[:alert] = "It seems your credentials are not authentic or something went wrong."
			redirect_to :back
		end
	end

	def update
		@tpf = current_user.topcoder_profile

		if @tpf.nil?
			flash[:alert] = "You don't have Github account integrated with your profile."
			redirect_to :back
		else
			if @tpf.updated_at < Time.now - 12.hours

				handle = @tpf.handle
				response_info = TopcoderProfile.connect(handle)
				status_info = response_info["status"]

				if status_info=="OK"
					response_info = TopcoderProfile.refine_basic_info(response_info)

					@tpf.update_attributes(data: response_info)

					response_achivs = TopcoderProfile.get_achievements(handle)
					status_achivs = response_achivs["status"]

					if status_achivs=="OK"
						data = @tpf.data
						achievements = TopcoderProfile.refine_achievements(response_achivs)
						data.merge!("achievements" => achievements)

						@tpf.data = data
						@tpf.data_will_change!
						@tpf.save!

						flash[:notice] = "You have successfully integrated Topcoder in your profile."
						redirect_to profile_path(username: current_user.username)
					else
						flash[:alert] = "Sorry, something went wrong. Try again later."
						redirect_to :back
					end
				else
					flash[:alert] = "It seems your credentials are not authentic or something went wrong."
					redirect_to :back
				end
			else
				flash[:alert] = "Don't update frequently. Wait for atleast 12 hours."
				redirect_to :back
			end
		end
	end

	def show_tcp_profile
		@user = User.where(username: params[:username]).first
		@tcp = @user.topcoder_profile

		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end

		respond_to do |format|
			format.js
		end
	end

end
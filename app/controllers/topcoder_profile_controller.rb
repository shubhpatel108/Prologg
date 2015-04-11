class TopcoderProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:new, :create]

	def new
	end

	def create
		handle = params[:handle]

		begin
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

				#Update Last updated at attribute
				current_user.profile_updated_at = Time.now
				current_user.save!
				current_user.reload

				flash[:notice] = "You have successfully integrated Topcoder in your profile."
				redirect_to profile_path(username: current_user.username)
			else
				flash[:alert] = "It seems your credentials are not authentic or something went wrong."
				redirect_to :back
			end
		rescue Exception => e
			tcp = current_user.topcoder_profile
			unless tcp.nil?
				tcp.destroy
			end
			flash[:alert] = "It seems your credentials are not authentic or something went wrong."
			redirect_to :back
		end
	end

	def update
		@tpf = current_user.topcoder_profile

		if @tpf.nil?
			flash[:alert] = "You don't have Topcoder account integrated with your profile."
			redirect_to :back
		else
			if @tpf.updated_at < Time.now - 12.hours
				begin
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

							#Update Last updated at attribute
							current_user.profile_updated_at = Time.now
							current_user.save!
							current_user.reload

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
				rescue Exception => e
					@tpf.data = old_data
					@tpf.data_will_change!
					@tpf.save!
					current_user.reload
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
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		else
			@tcp = @user.topcoder_profile


			respond_to do |format|
				format.js
				format.html
			end
		end
	end

	def delete
		unless current_user.topcoder_profile.nil?
			TopcoderProfile.where(:user => current_user).first.destroy
	 		current_user.save!
	 		current_user.reload
	 	end
		respond_to do |format|
			format.js
		end	
	end

end
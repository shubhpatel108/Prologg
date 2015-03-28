class TopcoderProfileController < ApplicationController
	before_filter :authenticate_user!

	def new
	end

	def create
		handle = params[:handle]

		response_info = TopcoderProfile.connect(handle)
		status_info = response_info["status"]

		if status_info=="OK"
			response_info.delete("handle")
			response_info.delete("status")
			response_info.delete("country")
			response_info["ratingsSummary"].each do |rating|
				rating.delete("colorStyle")
			end
			
			@tpf = TopcoderProfile.create(user_id: current_user.id, handle: handle, data: response_info)
			
			response_achivs = TopcoderProfile.get_achievements(handle)
			status_achivs = response_achivs["status"]

			if status_achivs=="OK"
				achievements = response_achivs["result"]
				achievements.each do |a|
					a["badgeLink"].delete("url")
				end
				data = @tpf.data
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
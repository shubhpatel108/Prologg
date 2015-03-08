class CodeforcesProfileController < ApplicationController
	before_filter :authenticate_user!

	def new
	end

	def create
		handle = params[:handle]
		response = CodeforcesProfile.connect(handle)
		status = response[0]
		resp = response[1]["result"][0]
		if status == "OK"
			CodeforcesProfile.create(
				user_id: current_user.id,
				handle: resp["handle"],
				contribution: resp["contribution"],
				rank: resp["rank"],
				max_rank: resp["maxRank"],
				rating: resp["rating"],
				max_rating: resp["maxRating"],
				last_online: DateTime.strptime(resp["lastOnlineTimeSeconds"].to_s, '%s')
				)
			flash[:notice] = "You have successfully integrated Codeforces in your profile."
			redirect_to profile_path(username: current_user.username)
		else
			flash[:alert] = "It seems your credentials are not authentic."
			redirect_to :back
		end
	end

end

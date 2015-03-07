class ProfilesController < ApplicationController

	def index
	end

	def show
		username = params[:username]
		@user = User.where(username: username).first
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end
	end

end

class ProfilesController < ApplicationController

	def index
	end

	def show
		username = params[:username]
		@user = User.where(username: username).first
		if @user.nil?
			render status: 404, template: '404.html'
		end
	end

end

class GithubProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:create]

	def create
		github = Github.new
		username = params[:github_username] #here username refers to that of github
		metadata = {}
		@github_profile = GithubProfile.where(:user_id => current_user.id).first

		repos = @github_profile.repos
		metadata.merge!(:repos => repos)

		activities = @github_profile.activities
		metadata.merge!(:activities => activities)

		activities_received = @github_profile.activities_received
		metadata.merge!(:interested_people => activities_received)

		metadata.merge!(:followers_count => @github_profile.followers_count )

		orgs = @github_profile.orgs
		metadata.merge!(:orgs => orgs)

		@github_profile.data = metadata
		@github_profile.data_will_change!
		@github_profile.save!

		flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
		redirect_to profile_path(:username => current_user.username)
	end

	def show
		@user = User.where(username: params[:username]).first
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end
		@ghp = @user.github_profile #ghi stands for GitHubProfile
		@orgs = @ghp.data["orgs"].paginate(page: params[:page], per_page: 4 )
		@repos = @ghp.data["repos"].paginate(page: params[:page], per_page: 5)
		respond_to do |format|
			format.js
		end
	end

end

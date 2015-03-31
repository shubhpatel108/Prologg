class GithubProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:create]

	def create
		github = Github.new basic_auth: "#{ENV['GIT_U']}:#{ENV['GIT_PWD']}"
		username = params[:github_username] #here username refers to that of github
		metadata = {}
		@github_profile = GithubProfile.where(:user_id => current_user.id).first

		data1 = @github_profile.followers_and_last_updated(github)
		metadata.merge!(:followers_count => data1[0])
		metadata.merge!(:last_updated => data1[1])

		repos = @github_profile.repos(github)
		metadata.merge!(:repos => repos)

		activities = @github_profile.activities(github)
		metadata.merge!(:activities => activities)

		activities_received = @github_profile.activities_received(github)
		metadata.merge!(:interested_people => activities_received)

		orgs = @github_profile.orgs(github)
		metadata.merge!(:orgs => orgs)


		@github_profile.data = metadata
		@github_profile.data_will_change!
		@github_profile.save!

		flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
		redirect_to profile_path(:username => current_user.username)
	end

	def update
		github = Github.new basic_auth: "#{ENV['GIT_U']}:#{ENV['GIT_PWD']}"
		@github_profile = current_user.github_profile

		if @github_profile.nil?
			flash[:alert] = "You don't have GitHub account integrated with your profile."
			redirect_to :back
		else
			new_data = {}

			data1 = @github_profile.followers_and_last_updated(github)
			new_data.merge!(:followers_count => data1[0])
			new_data.merge!(:last_updated => data1[1])

			if @github_profile.data["last_updated"] < new_data[:last_updated]
				repos = @github_profile.repos(github)
				new_data.merge!(:repos => repos)

				activities = @github_profile.activities(github)
				new_data.merge!(:activities => activities)

				activities_received = @github_profile.activities_received(github)
				new_data.merge!(:interested_people => activities_received)

				orgs = @github_profile.orgs(github)
				new_data.merge!(:orgs => orgs)

				@github_profile.data = new_data
				@github_profile.data_will_change!
				@github_profile.save!
				flash[:notice] = "Successfully updated your GitHub profile!"
				redirect_to profile_path(username: current_user.username)
			else
				flash[:notice] = "Your Github profile is already upto date."
				redirect_to :back
			end
		end
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

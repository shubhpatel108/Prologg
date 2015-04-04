class GithubProfileController < ApplicationController
	before_filter :authenticate_user!, only: [:create]

	def create
		@github_profile = GithubProfile.where(:user_id => current_user.id).first
		github = Github.new oauth_token: @github_profile.token

		username = @github_profile.username #here username refers to that of github
		metadata = @github_profile.data

		data1 = @github_profile.punch_card_and_repos(github)
		metadata.merge!(:punch_card => data1[0])
		metadata.merge!(:repos => data1[1])


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
		@github_profile = current_user.github_profile
		github = Github.new oauth_token: @github_profile.token

		if @github_profile.nil?
			flash[:alert] = "You don't have GitHub account integrated with your profile."
			redirect_to :back
		else
			new_data = {}

			resp = github.users.get user: @github_profile.username
			new_data.merge!(:followers_count => resp.followers)
			new_data.merge!(:last_updated => resp.updated_at)

			if @github_profile.data["last_updated"] < new_data[:last_updated] or true

				data1 = @github_profile.punch_card_and_repos(github)
				new_data.merge!(:punch_card => data1[0])
				new_data.merge!(:repos => data1[1])

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
		if not @ghp.nil?
			@orgs = @ghp.data["orgs"].paginate(page: params[:page], per_page: 4 ) unless @ghp.data["orgs"].nil?
			@repos = @ghp.data["repos"].paginate(page: params[:page], per_page: 5) unless @ghp.data["repos"].nil?
		end
		respond_to do |format|
			format.js
		end
	end

	def delete
		#@provider = Devise.omniauth_providers[0]
		unless current_user.github_profile.nil?
			GithubProfile.where(:user => current_user).first.destroy
	 		current_user.save!
	 		current_user.reload
	 	end
		respond_to do |format|
			format.js
		end	
	end
end

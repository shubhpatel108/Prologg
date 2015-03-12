class GithubProfileController < ApplicationController

	def create
		github = Github.new
		username = params[:github_username] #here username refers to that of github
		metadata = {}

		repos = (github.repos.list user: username).body
		repos.each do |repo|
			repo.select! {|k,v| ["name", "fork", "stargazers_count", "watchers_count"].include?(k)}
			contribution = (github.repos.stats.contributors user: username, repo: repo.name).body
			contribution.select! {|c| c.author.login==username}
			repo.merge!(:owner_commits => if contribution.empty? then 0 else contribution.map(&:total).sum end)
			repo.merge!(:languages => (github.repos.languages username, repo.name).body)
		end
		metadata.merge!(:repos => repos)

		activities = (github.activity.events.performed 'shubhpatel108').body
		user_activities = {}
		user_activities.merge!(:issues_created => activities.map(&:type).select {|e| e=="IssuesEvent"}.count)
		user_activities.merge!(:total_prs => activities.map(&:type).select {|e| e=="PullRequestEvent"}.count)
		user_activities.merge!(:merged_prs => activities.map(&:type).select {|e| e=="PullRequestEvent" && e.payload.pull_request.merged?}.count)
		metadata.merge!(:activities => :user_activities)

		activities_rec = (github.activity.events.received user: username).body
		metadata.merge!(:interested_people => activities_rec.map(&:actor).uniq.count)

		metadata.merge!(:followers_count => (github.users.followers.list username).body.count )

		orgs = (github.orgs.list user: 'shubhpatel108').body
		orgs.each do |org|
			org.select! {|k,v| ["login"].include?(k)}
			org.merge!(:members_count => (github.orgs.members.list org.login).body.count )
		end

		metadata.merge!(:orgs => orgs)

		@github_profile = GithubProfile.where(:user_id => current_user.id).first
		@github_profile.data = metadata
		@github_profile.save!

		flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
		redirect_to profile_path(:username => current_user.username)
	end

end

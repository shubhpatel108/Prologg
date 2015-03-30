class GithubProfile < ActiveRecord::Base
	belongs_to :user

	def repos(github)
		repos = (github.repos.list user: self.username).body
		repos.each do |repo|
			repo.select! {|k,v| ["name", "fork", "stargazers_count", "watchers_count"].include?(k)}
			contribution = (github.repos.stats.contributors user: username, repo: repo.name).body
			contribution.select! {|c| c.author.login==username}
			repo.merge!(:owner_commits => if contribution.empty? then 0 else contribution.map(&:total).sum end)
			repo.merge!(:languages => (github.repos.languages username, repo.name).body)
		end
		repos
	end

	def activities(github)
		activities = (github.activity.events.performed self.username).body
		user_activities = {}
		user_activities.merge!(:issues_created => activities.map(&:type).select {|e| e=="IssuesEvent"}.count)
		user_activities.merge!(:total_prs => activities.map(&:type).select {|e| e=="PullRequestEvent"}.count)
		user_activities.merge!(:merged_prs => activities.select {|e| e.type=="PullRequestEvent" && e.payload.pull_request.merged?}.count)
		user_activities
	end

	def activities_received(github)
		activities_rec = (github.activity.events.received user: self.username).body
		activities_rec = activities_rec.map(&:actor).uniq.count
		activities_rec
	end

	def followers_and_last_updated(github)
		user = (github.users.get user: self.username).body
		followers_count = user.followers
		last_updated = user.updated_at
		return [followers_count, last_updated]
	end

	def orgs(github)
		orgs = (github.orgs.list user: self.username).body
		orgs.each do |org|
			org.select! {|k,v| ["login"].include?(k)}
			org.merge!(:members_count => (github.orgs.members.list org.login).body.count )
		end
	end
end

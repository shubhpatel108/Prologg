class GithubProfile < ActiveRecord::Base
	belongs_to :user

	def repos(github)
		username = self.username
		repos = (github.repos.list user: username).body
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

	def punch_card_and_repos(github)
		days = [0,0,0,0,0,0,0]
		time = []
		24.times do
			time << 0
		end

		repositories = []

		repos = (github.repos.list user: self.username).body
		repos.each do |repo|
			unless repo.fork
				resp = (github.repos.stats.punch_card user: self.username, repo: repo.name).body
				resp.each do |r|
					days[r[0]] = days[r[0]] + r[2]
					time[r[1]] = time[r[1]] + r[2]
				end
				r = {}
				r[:name] = repo.name
				r[:languages] = [repo["language"]]
				repositories << r
			end
		end

		cumulative_time = []
		8.times do
			cumulative_time << 0
		end
		(0..7).each do |i|
			index = i*3
			cumulative_time[i] = time[index] + time[index+1] + time[index+2]
		end

		punch_card = {}
		punch_card[:days] = days
		punch_card[:time] = cumulative_time
		return [punch_card, repositories]
	end
end

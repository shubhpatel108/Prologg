class LinkedinProfileController < ApplicationController

	def create
		linkedin_profile = current_user.linkedin_profile
		data = {}

		client = LinkedIn::Client.new(ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"])
		client.authorize_from_access(linkedin_profile.token, linkedin_profile.secret)

		network = client.connections(:fields => ["industry", "location"])
		# client.profile(id: linkedin_profile.uid)
		locmap = network.all.map {|h| if not (h.industry.nil? or h.location.nil?) then {i: h.industry, l: h.location.name} end}
		locmap.compact!

		locations = locmap.map{|h| h[:l]}
		locations = locations.uniq
		
		loc_count = Hash[locations.map {|x| [x, 0]}]
		locmap.each do |data|
			loc_count[data[:l]] = loc_count[data[:l]] + 1
		end
		data[:loc_count] = loc_count

		@skills = client.profile(:fields => 'skills').skills
		if @skills.nil?
			@skills = []
		else
			@skills = @skills.all.map {|h| h.skill.name}
		end
		data[:skills] =  @skills

		@awards = client.profile(:fields => 'honors-awards').honors_awards
		if @awards.nil?
			@awards = []
		else
			@awards = @awards.all.map {|h| Hash.new(:name => h.name, :issuer => h.issuer)}
			i = 0
			@awards.each do |hash|
				hash[:id] = i + 1
			end
		end
		data[:awards] =  @awards

		@courses = client.profile(:fields => 'courses').courses
		if @courses.nil?
			@courses = []
		else
			@courses = @courses.all.map {|h| Hash.new(name: h.name)}
			i = 0
			@courses.each do |hash|
				hash[:id] = i + 1
			end
		end
		data[:courses] = @courses

		linkedin_profile.data = data 
		linkedin_profile.data_will_change!
		linkedin_profile.save!

		current_pos = client.profile(:fields => 'three-current-positions').three_current_positions.all[0]
		@short_bio = current_pos.title +", "+ current_pos.company.name if current_user.short_bio.nil?

		flash[:notice] = "You have successfully integrated LinkedIn in your profile."
		redirect_to profile_path(username: current_user.username)
	end

	def refine
		redirect_to profile_path(current_user.username)
	end

	def show_profile
		@user = User.where(username: params[:username]).first
		@lip = @user.linkedin_profile.data
		respond_to do |format|
			format.js
		end
	end
end
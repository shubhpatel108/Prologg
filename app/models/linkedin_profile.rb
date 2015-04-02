class LinkedinProfile < ActiveRecord::Base

	def location(client)
		client.profile(:fields => 'location').location.name
	end

	def network(client)
		network = client.connections(:fields => ["industry", "location"])
		locmap = network.all.map {|h| if not (h.industry.nil? or h.location.nil?) then {i: h.industry, l: h.location.name} end}
		locmap.compact!

		locations = locmap.map{|h| h[:l]}
		locations = locations.uniq
		locations = locations.compact

		loc_count = Hash[locations.map {|x| [x, 0]}]
		locmap.each do |data|
			loc_count[data[:l]] = loc_count[data[:l]] + 1
		end
		loc_count
	end

	def skills(client)
		skills = client.profile(:fields => 'skills').skills
		if skills.nil?
			skills = []
		else
			skills = skills.all.map {|h| h.skill.name}
		end
		skills
	end

	def awards(client)
		awards = client.profile(:fields => 'honors-awards').honors_awards
		if awards.nil?
			@awards = []
		else
			@awards = []
			awards.all.each do |h|
				a = Hash.new
				a[:name] = h[:name]
				a[:issuer] = h[:issuer]
				@awards << a
			end
		end
		@awards
	end

	def following(client)
		f = client.profile(:fields => "following")
		companies  = f.following.companies.all.map {|h| h.name}
		companies.compact!

		industries  = f.following.industries.all.map {|h| h.name}
		industries.compact!

		people  = f.following.people.all.map {|h| h.name}
		people.compact!

		spl_editions  = f.following.special_editions.all.map {|h| h.name}
		spl_editions.compact!

		return companies + industries + people + spl_editions
	end

end

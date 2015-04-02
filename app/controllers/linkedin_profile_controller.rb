class LinkedinProfileController < ApplicationController
	include Geocoder
	before_filter :authenticate_user!, only: [:new, :create]

	def create
		linkedin_profile = current_user.linkedin_profile
		data = {}

		client = LinkedIn::Client.new(ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"])
		client.authorize_from_access(linkedin_profile.token, linkedin_profile.secret)

		data[:location] = linkedin_profile.location(client)

		network = linkedin_profile.network(client)
		# client.profile(id: linkedin_profile.uid)

		data[:loc_count] = linkedin_profile.network(client)

		data[:skills] =  linkedin_profile.skills(client)

		data[:awards] =  linkedin_profile.awards(client)

		courses = client.profile(:fields => 'courses').courses
		if courses.nil?
			@courses = []
		else
			@courses = []
			courses.all.each do |h|
				a = Hash.new
				a[:name] = h[:name]
				@courses << a
			end
		end
		data[:courses] = @courses

		current_pos = client.profile(:fields => 'three-current-positions').three_current_positions.all[0]
		linkedshort_bio = current_pos.title +", "+ current_pos.company.name if current_user.short_bio.nil?

		data[:following] = linkedin_profile.following(client)

		linkedin_profile.data = data
		linkedin_profile.data_will_change!
		linkedin_profile.save!

		flash[:notice] = "You have successfully integrated LinkedIn in your profile."
		redirect_to profile_path(username: current_user.username)
	end

	def refine
		redirect_to profile_path(current_user.username)
	end

	def show_profile
		@user = User.where(username: params[:username]).first

		unless @user.linkedin_profile.nil?
			@lip = @user.linkedin_profile.data
			
			Geocoder.configure(:timeout => 5000)
			@geocoder = Geocoder
			
			@locations = Location.all
			@places = []

			unless @lip["loc_count"].nil?
				@lip["loc_count"].each do |place, count|
					existing = @locations.where(name: place).first
					if existing.nil?
						long_lat = @geocoder.coordinates(place)
						if not long_lat.nil?
							Location.create(name: place, latitude: long_lat[0], longitude: long_lat[1])
							@places << [long_lat[0], long_lat[1], count]
						end
					else
						@places << [existing.latitude, existing.longitude, count]
					end
				end
			end
		end

		respond_to do |format|
			format.js
		end
	end

	def delete
		unless current_user.linkedin_profile.nil?
			LinkedinProfile.where(:user => current_user).first.destroy
	 		current_user.save!
	 		current_user.reload
	 	end
		respond_to do |format|
			format.js
		end	
	end
end
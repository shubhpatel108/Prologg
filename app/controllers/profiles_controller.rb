class ProfilesController < ApplicationController
	before_filter :authenticate_user!, only: [:edit_links, :update_links]

	def index
		# if !current_user.nil?
		# 	redirect_to profile_path(current_user.username)
		# else
		# 	redirect_to new_user_session_path
		# end
	end

	def show
		username = params[:username]
		@user = User.where(username: username).first
		session[:viewed_profiles] = [] if session[:viewed_profiles].nil?	

		if  not @user.nil? and not @user==current_user and not session[:viewed_profiles].include?(@user.id)
			view = @user.view_count+1
			session[:viewed_profiles] << @user.id
			@user.update_attributes(view_count: view)
		end
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end
	end

	def edit_links
		current_user
		@website_link = current_user.website_link
		if @website_link.nil? then @website_link = "" else @website_link.url end

		if current_user.website_link.nil?
			@website_link = ""
		else
			@website_link = current_user.website_link.url
		end

		if current_user.blog_link.nil?
			@blog_link = ""
		else
			@blog_link = current_user.blog_link.url
		end

		if current_user.gplus_link.nil?
			@gplus_link = ""
		else
			@gplus_link = current_user.gplus_link.nurl
		end

		if current_user.facebook_link.nil?
			@facebook_link = ""
		else
			@facebook_link = current_user.facebook_link.nurl
		end

		if current_user.twitter_link.nil?
			@twitter_link = ""
		else
			@twitter_link = current_user.twitter_link.nurl
		end

		if current_user.quora_link.nil?
			@quora_link = ""
		else
			@quora_link = current_user.quora_link.url
		end

	end

	def update_links
		logger.info(params)
		u = current_user
		params[:gplus_link] = GplusLink.normalize_url(params[:gplus_link])
		params[:facebook_link] = FacebookLink.normalize_url(params[:facebook_link])
		params[:twitter_link] = TwitterLink.normalize_url(params[:twitter_link])

		if not u.website_link.nil?
			u.website_link.url = params[:website_link]
			u.website_link.save!
		elsif params[:website_link]!=""
			WebsiteLink.create(user_id: u.id, url: params[:website_link])
		end

		if not u.blog_link.nil?
			u.blog_link.url = params[:blog_link]
			u.blog_link.save!
		elsif params[:blog_link]!=""
			BlogLink.create(user_id: u.id, url: params[:blog_link])
		end

		if not u.gplus_link.nil?
			u.gplus_link.url = params[:gplus_link]
			u.gplus_link.save!
		elsif params[:gplus_link]!=""
			GplusLink.create(user_id: u.id, url: params[:gplus_link])
		end

		if not u.facebook_link.nil?
			u.facebook_link.url = params[:facebook_link]
			u.facebook_link.save!
		elsif params[:facebook_link]!=""
			FacebookLink.create(user_id: u.id, url: params[:facebook_link])
		end

		if not u.twitter_link.nil?
			u.twitter_link.url = params[:twitter_link]
			u.twitter_link.save!
		elsif params[:twitter_link]!=""
			TwitterLink.create(user_id: u.id, url: params[:twitter_link])
		end

		if not u.quora_link.nil?
			u.quora_link.url = params[:quora_link]
			u.quora_link.save!
		elsif params[:quora_link]!=""
			QuoraLink.create(user_id: u.id, url: params[:quora_link])
		end

		redirect_to :root
	end

	def edit_integrations
		respond_to do |format|
			format.js
		end
	end

	def search
	end

	def search_filter
		if not params[:locations].nil? and not params[:locations].empty?
			locations = Location.all
			locs = locations.select {|l| params[:locations].any? { |s| l.name.include?(s) } }
			@users = locs.map{|l| l.users.to_a}.flatten
		else
			@users = User.all.to_a
		end

		@users = @users.select {|user| user.username.downcase.include?(params[:username].downcase) and user.full_name.downcase.include?(params[:name].downcase) }

		@skills_req = params[:skills]
		if not @skills_req.nil? and not @skills_req.empty?
			@users = @users.select {|user|
				lp = user.linkedin_profile
				if lp.nil?
					false
				elsif lp.data["skills"] && @skills_req == @skills_req
					true
				else
					false
				end
			}
		end

		@languages_req = params[:languages]
		if not @languages_req.nil? and not @languages_req.empty?
			lang_users = Language.where(name: @languages_req).map{|l| l.users.to_a}.flatten
			@users = @users & lang_users
		end

		respond_to do |format|
			format.js
		end
	end

	def show_summary
		@show_summary_page = true
		@user = User.where(username: params[:username]).first
		@first_name = @user.full_name.split(" ").first

		@algo_langs = @user.algo_langs
		@application_langs = @user.application_langs
		@all_langs = @user.all_langs(@application_langs.dup, @algo_langs.dup)

		@github_profile = @user.github_profile

		@linkedin_profile = @user.linkedin_profile
		unless @linkedin_profile.nil?
			@industry = @linkedin_profile.data["industry"]
		end

		respond_to do |format|
			format.js
			format.html
		end
	end
end

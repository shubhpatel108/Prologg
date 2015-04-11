class ProfilesController < ApplicationController
	before_filter :authenticate_user!, only: [:edit_links, :update_links]

	def index
		if user_signed_in?
			redirect_to profile_path(current_user.username)
		else
			redirect_to :home
		end
	end

	def home
	end

	def show
		username = params[:username]
		@user = User.where(username: username).first
		session[:viewed_profiles] = [] if session[:viewed_profiles].nil?	
		@first_name = @user.full_name.split(" ").first

		@algo_langs = @user.algo_langs
		@application_langs = @user.application_langs
		@all_langs = @user.all_langs(@application_langs.dup, @algo_langs.dup)

		@github_profile = @user.github_profile
		@codeforces_profile = @user.codeforces_profile

		@linkedin_profile = @user.linkedin_profile
		unless @linkedin_profile.nil?
			@industry = @linkedin_profile.data["industry"]
		end
		if  not @user.nil? and not @user==current_user and not session[:viewed_profiles].include?(@user.id)
			view = @user.view_count+1
			session[:viewed_profiles] << @user.id
			@user.update_attributes(view_count: view)
		end
		if @user.nil?
			render file: 'public/404', status: 404, formats: [:html]
		end

		respond_to do |format|
			format.js
			format.html
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

		if current_user.stack_link.nil?
			@stack_link = ""
		else
			@stack_link = current_user.stack_link.nurl
		end
	end

	def update_links
		logger.info(params)
		u = current_user
		params[:gplus_link] = GplusLink.normalize_url(params[:gplus_link])
		params[:facebook_link] = FacebookLink.normalize_url(params[:facebook_link])
		params[:twitter_link] = TwitterLink.normalize_url(params[:twitter_link])
		params[:stack_link] = StackLink.normalize_url(params[:stack_link])

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

		if not u.stack_link.nil?
			u.stack_link.url = params[:stack_link]
			u.stack_link.save!
		elsif params[:stack_link]!=""
			StackLink.create(user_id: u.id, url: params[:stack_link])
		end

		redirect_to :root
	end

	def edit_integrations
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
				elsif not lp.data["skills"].nil? && lp.data["skills"].include?(@skills_req)
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
end

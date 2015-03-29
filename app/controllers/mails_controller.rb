class MailsController < ApplicationController
  def new
  	@username = params[:username]
  	respond_to do |format|
  		format.js
  	end
  end

  def send_mail
		user = User.where(username: params[:username]).first
		mail=params[:mail]
		sender= current_user
	    ContactMailer.send_mail(user.email, mail["subject"], mail["content"],sender).deliver
		redirect_to(profile_path(user.username))
	end
end

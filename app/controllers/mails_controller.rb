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
	    MailNotification.create(:sender_id => sender.id, :receiver_id => user.id)
		redirect_to(profile_path(user.username))
	end

	def delete
		@id = params[:id]
		MailNotification.where(id: @id).first.destroy
		@new_count = current_user.mail_notifications.where(status: false).length
		respond_to do |format|
			format.js
		end
	end

	
end

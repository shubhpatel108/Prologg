class MailsController < ApplicationController
  def new
  	@username = params[:username]
  	respond_to do |format|
  		format.js
  	end
  end

  def send_mail
		if params[:mail][:content].empty? or params[:mail][:content].empty?
			redirect_to profile_path(params[:username]), alert: "Please don't leave subject or content empty."
		else
			user = User.where(username: params[:username]).first
			mail=params[:mail]
			sender= current_user
			ContactMailer.send_mail(user.email, mail["subject"], mail["content"],sender).deliver
			MailNotification.create(:sender_id => sender.id, :receiver_id => user.id)
			redirect_to profile_path(user.username), notice: "Message delivered!"
		end
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

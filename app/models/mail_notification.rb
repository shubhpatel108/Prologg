class MailNotification < ActiveRecord::Base
	belongs_to :actor, :class_name => "User", :foreign_key => "sender_id"
	belongs_to :victim, :class_name => "User", :foreign_key => "receiver_id" 

end

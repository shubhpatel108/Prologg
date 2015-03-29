class ContactMailer < ActionMailer::Base
  default from: "services@prologg.me"

   def send_mail(recepient , subject, content,sender)
   	@recepient = recepient
   	@subject = subject
   	@content = content
	@sender = sender
    mail(to: recepient, subject: subject)
  end

end

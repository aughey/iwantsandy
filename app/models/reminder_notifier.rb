class ReminderNotifier < ActionMailer::Base
  
  def reminder_notification(recipient,email,reminder)
    recipients recipient
    from "sandy@washucsc.org"
    subject "I successfully setup a reminder"
    body :account => recipient, :email => email, :reminder => reminder
  end

end

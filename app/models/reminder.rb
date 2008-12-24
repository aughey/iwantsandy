class Reminder < ActiveRecord::Base
  belongs_to :raw_email
  after_create :deliver_email

  def deliver_email
    ReminderNotifier.deliver_reminder_notification(raw_email.from,raw_email,self)
  end
end

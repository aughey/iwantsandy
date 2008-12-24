require 'config/environment'

RawEmail.find(:all).each do |email|
  email.reminders.destroy_all
  email.parse_problems.destroy_all
  email.create_schedule
end

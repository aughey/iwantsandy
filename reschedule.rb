require 'config/environment'

SentEmail.destroy_all

RawEmail.find(:all).each do |email|
  email.reminders.destroy_all
  email.parse_problems.destroy_all
  puts "Creating email schedule for #{email.first_line}"
  email.create_schedule
end

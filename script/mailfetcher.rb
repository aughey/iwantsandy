# default rails environment to development
ENV['RAILS_ENV'] ||= 'development'
# require rails environment file which basically "boots" up rails for this script
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'net/imap'
require 'net/http'
require 'tmail'

# amount of time to sleep after each loop below
SLEEP_TIME = 60

# mail.yml is the imap config for the email account (ie: username, host, etc.)
config = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mail.yml')))

# this script will continue running forever
loop do
  begin
    # make a connection to imap account
    puts "Connecting to imap #{config['host']}"
    imap = Net::IMAP.new(config['host'], config['port'], true)
    puts "Logging in with #{config['username']}"
    imap.login(config['username'], config['password'])
    # select inbox as our mailbox to process
    puts "Selecting inbox"
    imap.select('Inbox')

    puts "Searching for not deleted e-mails"
    # get all emails that are in inbox that have not been deleted
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      puts "Found an e-mail"

      # fetches the straight up source of the email
      source   = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']

      email = RawEmail.create(:rfc822 => source)

      message = TMail::Mail.parse(source)
      puts "To: #{email.to}"
      puts "Body:"
      puts email.body

      imap.uid_copy(uid, "[Gmail]/All Mail")
      imap.uid_store(uid, "+FLAGS", [:Deleted])
    end

    puts "Expunging emails"
    imap.expunge
    imap.logout
    imap.disconnect

    # NoResponseError and ByResponseError happen often when imap'ing
  rescue Net::IMAP::NoResponseError => e
    puts "Net::IMAP::NoResponseError caught"
    # send to log file, db, or email
  rescue Net::IMAP::ByeResponseError => e
    puts "Net::IMAP::ByeResponseError caught"
    # send to log file, db, or email
  rescue => e
    puts "Some other exception caught #{e}"
    raise
    # send to log file, db, or email
  end

  puts "Done fetching mail.  Waiting #{SLEEP_TIME} seconds"

  # sleep for SLEEP_TIME and then do it all over again
  sleep(SLEEP_TIME)
end

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
    puts "Logging in with #{config['username']} #{config['password']}"
    imap.login(config['username'], config['password'])
    # select inbox as our mailbox to process
    puts "Selecting inbox"
    imap.select('Inbox')

    puts "Searching for not deleted e-mails"
    # get all emails that are in inbox that have not been deleted
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      puts "Found an e-mail"

      # fetches the straight up source of the email for tmail to parse
      source   = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']
      envelope = imap.uid_fetch(uid, ["ENVELOPE"])

#      puts "Source:"
#      puts source.inspect

#      puts "Envelope"
#      puts envelope.inspect
      message = TMail::Mail.parse(source)
      puts "To: #{message.to}"
      puts "Body:"
      puts message.body

      if false
        # Location#new_from_email accepts the source and creates new location
        location = Location.new_from_email(source)

        # check for an existing location that matches the one created from email source
        existing = Location.existing_address(location)

        if existing
          # location exists so update the sign color to the emailed location
          existing.signs = location.signs
          if existing.save
            # existing location was updated
          else
            # existing location was invalid
          end
        elsif location.save
          # emailed location was valid and created
        else
          # emailed location was invalid
        end
      end

      if false
        # there isn't move in imap so we copy to new mailbox and then delete from inbox
        imap.uid_copy(uid, "[Gmail]/All Mail")
        imap.uid_store(uid, "+FLAGS", [:Deleted])
      end
    end

    # expunge removes the deleted emails
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

  # sleep for SLEEP_TIME and then do it all over again
  sleep(SLEEP_TIME)
end

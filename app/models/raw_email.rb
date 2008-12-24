require 'chronic'
require 'stringio'

class RawEmail < ActiveRecord::Base
  has_many :parse_problems
  has_many :reminders

  after_create :create_schedule

  def from
    tmail.from
  end

  def to
    tmail.to
  end

  def body
    tmail.body
  end

  def first_line
    StringIO.new(self.body).readline
  end

  def create_schedule
    io = StringIO.new(self.body)

    toschedule = []
    io.each_line do |line|
      if line=~/^r (.*)/
        remind = $1
        time = Chronic.parse(remind)
        if time.nil?
          # Didn't find a parsable time.  This is a problem
          toschedule << self.parse_problems.new(:message => "Could not parse #{remind}")
        else
          # Found a valid parsable time.  Create a reminder
          toschedule << self.reminders.new(:time => time, :message => remind)
        end
      else
        break
      end
    end
    
    if toschedule.empty?
      toschedule << self.parse_problems.new(:message => "There were no reminder lines found")
    end

    for event in toschedule
      event.save!
    end
  end

  protected

  def tmail
    @tmail ||= TMail::Mail.parse(self.rfc822)
  end
end

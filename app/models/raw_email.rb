class RawEmail < ActiveRecord::Base
  def to
    tmail.to
  end

  def body
    tmail.body
  end

  protected

  def tmail
    @tmail ||= TMail::Mail.parse(self.rfc822)
  end
end

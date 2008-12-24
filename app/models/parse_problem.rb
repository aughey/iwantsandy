class ParseProblem < ActiveRecord::Base
  belongs_to :raw_email
  after_create :deliver_email
  has_many :sent_emails, :as => :parent

  def deliver_email
    email = ProblemNotifier.create_problem_notification(raw_email.from,raw_email)
    self.sent_emails.create(:rfc822 => email.to_s)
    ProblemNotifier.deliver(email)
  end
end

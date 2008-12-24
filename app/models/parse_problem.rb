class ParseProblem < ActiveRecord::Base
  belongs_to :raw_email
  after_create :deliver_email

  def deliver_email
    ProblemNotifier.deliver_problem_notification(raw_email.from,raw_email)
  end
end

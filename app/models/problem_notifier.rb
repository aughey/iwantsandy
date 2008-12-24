class ProblemNotifier < ActionMailer::Base
  def problem_notification(recipient,email)
    recipients recipient
    from "sandy@washucsc.org"
    subject "Problem with your reminder"
    body :account => recipient, :email => email
  end
end

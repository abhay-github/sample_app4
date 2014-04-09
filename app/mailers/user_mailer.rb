class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.follower_notification.subject
  #
  def follower_notification
    @greeting = "Hi"

    mail to: "abhayemailid@gmail.com", subject: "You got a new follower"
  end
end

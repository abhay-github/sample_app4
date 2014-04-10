class UserMailer < ActionMailer::Base
  default from: "alerts@chirrups.com"

  def follower_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "You got a new follower"
  end
end

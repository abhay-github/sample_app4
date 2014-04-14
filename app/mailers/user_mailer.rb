class UserMailer < ActionMailer::Base
  default from: "alerts@chirrups.com"

  def follower_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "You got a new follower"
  end

  def password_reset(user)
  	@user = user
  	mail to: user.email, subject: "Password reset request: chirrups"
  end
end

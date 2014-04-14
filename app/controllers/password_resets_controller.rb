class PasswordResetsController < ApplicationController
  
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	# send email to the user
  	user.send_password_reset if user
    # raise user.password_reset_token.inspect
  	redirect_to root_path, notice: "Email sent with password reset instructions."
  end

  def edit
  	@user = User.find_by!(password_reset_token: params[:id])
    # @user = User.find_by!(id: params[:id])
  end

  def update
  	@user = User.find_by(password_reset_token: params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
  		redirect_to new_password_reset_path, alert: "Password reset has expired."
	elsif @user.update_attributes(user_params)
		redirect_to root_path, notice: "Password has been reset successfully."
	else
		render 'edit'
	end	
  end

  private

  	# def user_params
  	# 	params.require(:user).permit(:password, :password_confirmation)
  	# end
  
end

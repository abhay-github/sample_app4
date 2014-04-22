class SessionsController < ApplicationController

	include SessionsHelper
	
	def new
	end

	def create
		user_input = params[:session][:email_username]
		user = User.find_by(email: user_input) || User.find_by(username: user_input)
		if user && user.authenticate(params[:session][:password])
			if user.activated_state == true
				sign_in user
				redirect_back_or(root_path)
			else
				flash[:error] = 'Please confirm your signup from your mailbox to activate your account. Thanks!'
				redirect_to root_path
			end
		else
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end

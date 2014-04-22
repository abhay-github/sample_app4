module SessionsHelper
	def sign_in(user)
		rt = User.new_remember_token
		cookies.permanent[:remember_token] = rt
		user.update_attribute(:remember_token, User.hash(rt))
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		rt = User.hash(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: rt)
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		current_user.update_attribute(:remember_token,
							User.hash(User.new_remember_token))
		cookies.delete(:remember_token)
		session.delete(:viewMsgs)
		self.current_user = nil
	end

	def store_location
        session[:return_to] = request.url if request.get?
	end

	def redirect_back_or(user)
		if session[:return_to]
			redirect_to session[:return_to]
			session.delete :return_to
		else
			redirect_to user
		end
	end


	def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." 
      end
    end

end

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

	def sign_out
		current_user.update_attribute(:remember_token,
							User.hash(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil

	end
end

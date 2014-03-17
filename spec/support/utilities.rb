include ApplicationHelper

def sign_in(user, options={})
	if options[:no_capybara]
    # Sign in when not using Capybara.
		remember_token = User.new_remember_token
	    cookies[:remember_token] = remember_token
	    user.update_attribute(:remember_token, User.hash(remember_token))
	else
		parameter = options[:using_username] ? user.username : user.email
		visit signin_path
		fill_in "Email or Username", with: parameter
		fill_in "Password", with: user.password
		click_button 'Sign in'
	end			
end
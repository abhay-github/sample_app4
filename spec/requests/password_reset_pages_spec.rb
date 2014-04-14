require 'spec_helper'

describe "Password Reset" do

	subject	{ page }

	let!(:user) { FactoryGirl.create(:user) }

	before do
		visit new_password_reset_path
		fill_in "Email",	with: user.email 
		click_button "Submit"
	end

	it { should have_selector "div.alert", text: "Email sent with password reset instructions." }

	describe "filling in new password" do
		before	do
			user.password_reset_token = 'KnyCbzaU7B0wEhWdFDuxwA'
			user.save!(validate: false)
			visit edit_password_reset_url(user.password_reset_token)
		end

		describe "with invalid information" do
			before do
				fill_in "Password", with: "foo"
				fill_in "Password confirmation", with: "bar"
				click_button "Update Password"
			end
			it { should have_selector "div.alert", text:"error" }
		end

		describe "updating later than 2 hours" do
			
			before do
				user.update_attribute('password_reset_sent_at', 3.hours.ago)
				fill_in "Password", with: "foo"
				fill_in "Password confirmation", with: "bar"
				click_button "Update Password"
			end
			it { should have_selector "div.alert", text: "expired" 
}		end

		describe "with valid information" do
			before do
				fill_in "Password", with: "newPass"
				fill_in "Password confirmation", with: "newPass"
				click_button "Update Password"
			end

			it "should have the password changed" do
				visit signin_path
				fill_in "Email",	with: user.email
				fill_in "Password", 	with: "newPass"
				click_button "Sign in"
				expect(page).to have_link 'Sign out'
			end
		end
	end
end

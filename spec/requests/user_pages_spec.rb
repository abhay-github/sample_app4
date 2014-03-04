require 'spec_helper'

describe "UserPages" do

	let(:user) { FactoryGirl.create(:user) }
	# before	{ @user = User.find(1) }
	subject	{ page }

	describe "signup page" do
		before	{ visit signup_path }
		it { should have_title full_title('Sign up') }
		it { should have_content 'Sign up' }
	end

	describe "signup page" do
		before	{visit user_path user}
		it { should have_title full_title(user.name) }
		it { should have_content user.name }
	end

	describe "signup" do
		let(:submit) { "Create my account" }
		before	{ visit signup_path }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before	{ click_button submit }
				it { should have_title 'Sign up' }
				it { should have_content 'error' }
			end
		end

		describe "with valid information" do

			before do
				 fill_in "Name",	with: "Example User"
				 fill_in "Email", 	with: "user@example.com"
				 fill_in "Password",with: "foobar"
				 fill_in "Confirmation",with: "foobar"
			end

			it "should create a user" do
				 expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving a user" do
				let(:user) { User.find_by(email: "user@example.com") }
				before	{ click_button submit }
				it { should have_title user.name }
				it { should have_selector 'div.alert.alert-success', text: 'Welcome' }
				it { should have_link 'Sign out' }
			end
		end
	end
end

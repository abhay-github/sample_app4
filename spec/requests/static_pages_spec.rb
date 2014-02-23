require 'spec_helper'

describe "StaticPages" do

	subject	{ page }

	describe "home page" do

		before	{ visit root_path }

		it { should have_content 'Sample App' }
		it { should have_title full_title('') }
		it { should_not have_title '| Home' }
	end

	describe "help page" do

		before	{ visit help_path }

		it { should have_content 'Help' }
		it { should have_title full_title('Help') }
	end

	describe "about page" do

		before	{ visit about_path }

		it { should have_content 'About Us' }
		it { should have_title full_title('About') }
	end

	describe "contact page" do

		before	{ visit contact_path }

		it { should have_content 'Contact' }
		it { should have_title full_title('Contact') }
	end
	
end

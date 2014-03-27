require 'spec_helper'

describe "StaticPages" do

	subject	{ page }

	describe "home page" do

		before	{ visit root_path }

		it { should have_content 'Sample App' }
		it { should have_title full_title('') }
		it { should_not have_title '| Home' }

		describe "for signed in users" do
			let(:user) { FactoryGirl.create(:user) }
			let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "lorem ipsum dolor") }
			before do
			  FactoryGirl.create(:micropost, user: user, content: "lorem ipsum")
			  FactoryGirl.create(:micropost, user: user, content: "dolor sit amet")
			  sign_in user
			  visit root_path
			end

			it "should render the user's feed with delete links" do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
					expect(page).to have_link('delete', href: micropost_path(item))
				end

				expect { click_link 'delete', href: micropost_path(m1) }.to change(Micropost, :count).by(-1)	
			end

			describe "after deleting a user's feed, it should not be visible" do
				before { click_link 'delete', href: micropost_path(m1) }
				it { should_not have_selector "li##{m1.id}" }
			end

			describe "rendering other user's feeds" do
				let(:other_user) { FactoryGirl.create(:user) }
				let!(:m2) { FactoryGirl.create(:micropost, user: other_user, content:"some waste content") }
				before do
					user.follow!(other_user)
					visit root_path
				end

				it { should have_selector "li##{m2.id}", text: m2.content }
				it { should_not have_link 'delete', href: micropost_path(m2) }
			end

			describe "follower/following counts" do
				let(:other_user) { FactoryGirl.create(:user) }
				before do
				  other_user.follow!(user)
				  visit root_path
				end

				it { should have_link("0 following", href: following_user_path(user)) }
        		it { should have_link("1 followers", href: followers_user_path(user)) }
			end
		end
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

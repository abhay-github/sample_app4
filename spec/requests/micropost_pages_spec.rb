require 'spec_helper'

describe "MicropostPages" do

	subject	{ page }

	let(:user) { FactoryGirl.create(:user) }

	before	{ sign_in user }

	describe "display the count with pluralization" do
		before do
		  FactoryGirl.create(:micropost, user: user, content: "1st")
		  FactoryGirl.create(:micropost, user: user, content: "2nd")
		  visit root_path
		end


		it { should have_content "#{user.microposts.count} microposts" }
	end

	describe "micropost pagination" do
		before do
			50.times { FactoryGirl.create(:micropost, user: user) }
			visit root_path
		end

		it "should list each micropost" do
			Micropost.paginate(page: 1).each do |m|
				expect(page).to have_content m.content
			end
		end
	end

	describe "micropost creation" do
		before	{ visit root_path }

		describe "with invalid information" do
			it "should not create a micropost" do
				expect{ click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before	{ click_button "Post" }				
				it { should have_content 'error' }
			end
			
		end
	end

	describe "micropost destruction" do
		before do 
			FactoryGirl.create(:micropost, user: user)
		end
		
		describe "as correct user" do
			before { visit root_path }

			it "should be able to delete one's own micropost" do
				# expect(page).to have_link 'delete', href: micropost_path(m1)
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end

		end


		describe "should not be able to delete other users' microposts" do
			let(:other_user) { FactoryGirl.create(:user) }
			let!(:m2) { FactoryGirl.create(:micropost, user: other_user) }
				
			before do
			  	visit users_path(other_user)
			end

			it { should_not have_link 'delete', href: microposts_path(m2) }
		end

	end
end

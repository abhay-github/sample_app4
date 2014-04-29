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

		describe "with valid information" do
			before { fill_in 'micropost_content', with: "lorem ipsum dodlor" }
			it "should create a micropost" do
				expect{ click_button 'Post'}.to change(Micropost, :count).by(1)
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

	describe "reply links" do
		let(:other_user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user: other_user) }
		let!(:m2) { FactoryGirl.create(:micropost, user: user) }

		before do
			user.follow!(other_user)
			visit root_path
		end

		it { should_not have_selector "li##{m2.id} > a", text: "reply" }
		it { should have_selector "li##{m1.id} > a", text: "reply" }
	end

	describe "micropost searches" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			3.times {|i| FactoryGirl.create(:micropost, user: user, content: "content_#{i}") }
			FactoryGirl.create(:micropost, user: other_user, content: "lorem ipsum #{user.name}")
			FactoryGirl.create(:micropost, user: other_user)
			fill_in "search", with: user.name[2..-1]
			click_button "srch_btn"
		end
		3.times do |i|
			it { should have_content user.microposts.find(i+1).content }	
		end

		# note below why using first, last in reverse way
		it { should have_content other_user.microposts.last.content }
		it { should_not have_content other_user.microposts.first.content }

		it "should show sorry msg when no results found" do
			fill_in "search", with: "no_result_string"
			click_button "srch_btn"
			expect(page).to have_content "sorry"
		end
	end
end

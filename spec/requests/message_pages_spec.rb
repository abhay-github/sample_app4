require 'spec_helper'

describe "Message Pages" do
  
	subject	{ page }

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before	{ sign_in user }

	describe "message creation" do
		before	{ visit root_path }

		describe "with invalid information" do
			it "should not create a message" do
				expect{ click_button 'Post' }.not_to change(Message, :count)
			end

			describe "error messages" do
				before	{ click_button 'Post' }
				it { should have_content 'error' }
			end
		end

		describe "with valid information" do
			before	do 
				@old_count = Message.count
				fill_in 'micropost_content',
						 with: "d @#{other_user.username} where do i debug this?"
				click_button 'Post'
				@new_count = Message.count
			end

			it "should create the message" do
				@new_count.should == @old_count + 1
			end

			it { should have_selector("h3", text: "Messages") } 
			it { should have_selector("li", text: "where do i debug this?") }	
			# end
		end
	end

end

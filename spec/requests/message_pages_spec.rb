require 'spec_helper'

describe "Message Pages" do
  
	subject	{ page }

	let(:user) { FactoryGirl.create(:user) }

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
	end

end

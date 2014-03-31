require 'spec_helper'

describe Message do
	let(:user) { FactoryGirl.create(:user) }
	let(:receiver) { FactoryGirl.create(:user) }
	before do
		@message = Message.new(content: "Hi dear friend! thats a direct message",
								user: user, receiver: receiver )
	end
  	subject	{ @message }

  	it { should be_valid }

  	it { should respond_to :user }
  	it { should respond_to :receiver }
  	it { should respond_to :content }
  	its(:user) { should eq user }

  	describe "when user_id is not present" do
  		before { @message.user_id = " " }
  		it { should_not be_valid }
  	end

  	describe "when receiver_id is not present" do
  		before { @message.receiver_id = " " }
  		it { should_not be_valid }
  	end

  	describe "when content is not present" do
  		before { @message.content = " " }
  		it { should_not be_valid }
  	end
end

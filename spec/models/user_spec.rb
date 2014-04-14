require 'spec_helper'

describe User do
	before	{ @user = User.new(name:"Example User", username: "exampleuser",email:"user@example.com",
							password: "foobar", password_confirmation: "foobar") }

	subject	{ @user }

	it { should respond_to(:name) }
	it { should respond_to(:username) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
  	it { should respond_to(:password_confirmation) }
  	it { should respond_to(:remember_token) }
  	it { should respond_to(:admin) }
  	it { should respond_to :microposts }
  	it { should respond_to(:feed) }
  	it { should respond_to(:relationships) }
  	it { should respond_to(:followed_users) }
  	it { should respond_to(:followers) }
  	it { should respond_to(:reverse_relationships) }
  	it { should respond_to(:follow!) }
  	it { should respond_to(:unfollow!) }
  	it { should respond_to(:following?) }
  	it { should respond_to :messages }
  	it { should respond_to :password_reset_token }
  	it { should respond_to :password_reset_sent_at }

	it { should be_valid }
	it { should_not be_admin }

	describe "with admin attribute set to true" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when name is not present" do
		before	{ @user.name = " " }

		it { should_not be_valid }
	end

	describe "when name is too long" do
		before	{ @user.name = "a"*51 }

		it { should_not be_valid }
	end

	describe "when username is not present" do
		before	{ @user.username = " " }
		it { should_not be_valid }
	end

	describe "when username has whitespaces" do
		before	{ @user.username = "user name"}

		it { should_not be_valid }

		describe "but only in the beginning/end" do
			before	{ @user.username = " username" }
			it { should be_valid }
		end
	end

	describe "when username is already taken" do
		let!(:another_user) { FactoryGirl.create(:user, username: @user.username) }

		it { should_not be_valid }
	end

	describe "when email is not present" do
		before	{ @user.email = " " }

		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
	      	addresses = %w[user@foo,com user_at_foo.org example.user@foo.
	                     foo@bar_baz.com foo@bar+baz.com]
	      	addresses.each do |addr|
	      		@user.email = addr
	      		expect(@user).not_to be_valid
	      	end
      	end
	end

	describe "when email format is valid" do
		it "should be valid" do
	      	addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      	addresses.each do |addr|
	      		@user.email = addr
	      		expect(@user).to be_valid
	      	end
      	end
	end

	describe "when email address is already taken" do
	    before do
	      user_with_same_email = @user.dup
	      user_with_same_email.email = @user.email.upcase
	      user_with_same_email.save
	    end

	    it { should_not be_valid }
  	end

  	describe "when password is not present" do
  		before do
	    	@user = User.new(name: "Example User", username: "samplename", email: "user@example.com",
	                     password: " ", password_confirmation: " ")
	  	end
	  	it { should_not be_valid }
  	end

  	describe "when password doesn't match confirmation" do
  		before { @user.password_confirmation = "mismatch" }
  		it { should_not be_valid }
	end

	describe "when password is too short" do
		before	{ @user.password = "a"*5; @user.password_confirmation = "a"*5 }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before	{ @user.save }
		let(:found_user) { User.find_by(email: @user.email) } 

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:return_val_of_authenticate) { found_user.authenticate("mismatch") }

			it { should_not eq return_val_of_authenticate }
			specify { expect(return_val_of_authenticate).to be_false }
		end
	end

	describe "remember token" do
		before	{ @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "message associations" do
		before { @user.save }
		let!(:receiver) { FactoryGirl.create(:user) }

		let!(:older_msg) do
			FactoryGirl.create(:message, user: @user, receiver: receiver, created_at: 1.day.ago)
		end
		let!(:newer_msg) do
			FactoryGirl.create(:message, user: @user, receiver: receiver, created_at: 1.hour.ago)
		end
		let!(:rcvdMsgNew) do
			FactoryGirl.create(:message, user: receiver, receiver: @user, created_at: 2.hour.ago)
		end
		let!(:rcvdMsgOld) do
			FactoryGirl.create(:message, user: receiver, receiver: @user, created_at: 2.day.ago)
		end

		it "should have the right messages in the right order" do
			expect(@user.messages.to_a).to eq [newer_msg, older_msg]
			expect(@user.received_msgs.to_a).to eq [rcvdMsgNew, rcvdMsgOld]
		end

		it "should destroy the associated messages" do
			messages = @user.messages.to_a
			@user.destroy
			expect(messages).not_to be_empty
			messages.each do |msg|
				expect(Message.where(id: msg.id)).to be_empty
			end
		end


	end

	describe "micropost associations" do
		before	{ @user.save }

		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end
		
		it "should have the right microposts in the right order" do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it "should destroy the associated microposts" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |m|
				expect(Micropost.where(id: m.id)).to be_empty
			end
		end

		describe "status" do
			let(:unfollowed_post) do
			  FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end
			let(:followed_user) { FactoryGirl.create(:user) }

			before do
			  @user.follow!(followed_user)
			  3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
			end

			its(:feed) { should include older_micropost }
			its(:feed) { should include newer_micropost }
			its(:feed) { should_not include unfollowed_post }
			its(:feed) do
				followed_user.microposts.each do |m|
					should include m
				end
			end

			describe "feeds in reply to another user" do
				let(:user_replied_to) { FactoryGirl.create(:user) }
				let!(:m1) { FactoryGirl.create(:micropost, user: followed_user,
							 content:"@#{user_replied_to.username} a reply tweet to u") }
				

				its(:feed) { should_not include m1 }

				it "should be visible to poster" do
					expect(followed_user.feed).to include m1
				end

				it "should be visible to the reply receiver" do
					expect(user_replied_to.feed).to include m1
				end

				
			end

		end
	end

	describe "following" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
		  @user.save
		  @user.follow!(other_user)
		end

		it { should be_following(other_user) }
		its(:followed_users) { should include other_user }
	
		describe "and unfollowing" do
			before	{ @user.unfollow!(other_user) }

			it { should_not be_following other_user }
			its(:followed_users) { should_not include other_user }
		end
	end
end
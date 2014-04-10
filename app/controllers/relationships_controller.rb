class RelationshipsController < ApplicationController
	include SessionsHelper

	before_action :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		# send email to the @user
		if @user.follower_notification?
 			UserMailer.follower_notification(@user, current_user).deliver
 		end
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
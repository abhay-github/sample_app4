class MicropostsController < ApplicationController

	include SessionsHelper
	include MessagesHelper

	before_action :signed_in_user
	before_action :correct_user, only: :destroy

	def index
		srch = params[:search]
		if srch
			@micropost = current_user.microposts.build()

			@microposts = Micropost.joins(:user).where("users.name LIKE ? OR users.username LIKE ? OR microposts.content LIKE ?",
			 		"%#{srch}%", "%#{srch}%", "%#{srch}%")
		end
	end

	def create
		cntnt = params[:micropost][:content]
		if cntnt.match(MSG_CONTENT_REGEX)
			# handle the message creation
			msg_create(cntnt)
		else
			# handle a micropost creation
			@micropost = current_user.microposts.build(content: cntnt)
			if @micropost.save
				flash[:success] = "Micropost created!"
				session[:viewMsgs] = false
				redirect_to root_path
			else
				# Please use this if any error may come with future version of rails
				@feed_items = []
				# @feed_items = current_user.feed.paginate(page: params[:page])
				render 'static_pages/home'
			end

		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_path
	end

	private

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_path if @micropost.nil?
		end
end
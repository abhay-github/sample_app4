class StaticPagesController < ApplicationController

	include SessionsHelper
	
	def home
		if signed_in?
			@micropost =  current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
			@messages = current_user.messages
			@received_msgs = current_user.received_msgs
		end
	end

end

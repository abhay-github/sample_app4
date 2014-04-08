class StaticPagesController < ApplicationController

	include SessionsHelper
	include MessagesHelper
	
	def home
		if signed_in?
			@viewMsgs = session[:viewMsgs]
			if @viewMsgs
				msg_index_helper
			end

			@micropost =  current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
			respond_to do |format|
				format.js	{ session[:viewMsgs] = false; render }
				format.html
			end
		end
	end
end

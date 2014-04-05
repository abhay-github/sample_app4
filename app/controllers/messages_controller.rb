class MessagesController < ApplicationController

	include SessionsHelper

	before_action :signed_in_user

	def index
		@messages = current_user.messages
		@received_msgs = current_user.received_msgs
		respond_to do |format|
			format.js
			format.html
		end
	end

	def create
		
	end

	def destroy
		
	end
end
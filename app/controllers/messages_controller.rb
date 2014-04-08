class MessagesController < ApplicationController

	include MessagesHelper
	include SessionsHelper

	before_action :signed_in_user

	def index
		if signed_in?
			msg_index_helper
			respond_to do |format|
				format.js
				format.html
			end
		end
	end

	def create
		
	end

	def destroy
		
	end
end
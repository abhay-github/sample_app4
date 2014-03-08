class MicropostsController < ApplicationController

	include SessionsHelper

	before_action :signed_in_user

	def create
		redirect_to user_path(params[:id])
	end

	def destroy
		redirect_to user_path(params[:id])
	end

end
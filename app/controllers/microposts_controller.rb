class MicropostsController < ApplicationController

	include SessionsHelper

	before_action :signed_in_user
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(content: params[:micropost][:content])
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_path
		else
			# Please use this if any error may come with future version of rails
			@feed_items = []
			# @feed_items = current_user.feed.paginate(page: params[:page])
			render 'static_pages/home'
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
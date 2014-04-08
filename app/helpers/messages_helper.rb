module MessagesHelper

	MSG_CONTENT_REGEX = /\Ad\s+@[\w\-.]+/

	def msg_create(cntnt)
		@msg = current_user.messages.build()
		username = cntnt[/@[\w\-.]+/]
		username = username[1..-1]
		@msg.receiver = User.find_by(username: username)
		cntnt.slice! MSG_CONTENT_REGEX
		@msg.content = cntnt
		if @msg.save
			flash[:success] = "Message sent!"
			session[:viewMsgs] = true
			redirect_to root_path
		else
			# handle msg failure
			@micropost =  current_user.microposts.build
			@feed_items = []
			
			render 'static_pages/home'

		end
	end

	def msg_index_helper
		@messages = current_user.messages
		@received_msgs = current_user.received_msgs
		session[:viewMsgs] = true
	end

end
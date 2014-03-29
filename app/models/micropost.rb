class Micropost < ActiveRecord::Base

	belongs_to :user
	# belongs_to :replied_to, class_name: "User", foreign_key: "in_reply_to"

	before_create :check_if_reply

	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }

	default_scope -> { order 'microposts.created_at DESC' }
	# scope :including_replies, -> { where.not(in_reply_to: nil) }

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships WHERE
							follower_id = :user_id"
		where("(user_id IN (#{followed_user_ids}) AND in_reply_to IS NULL) 
			OR user_id = :user_id OR in_reply_to = :user_id", user_id: user.id)
	end

	def check_if_reply
		username = self.content[/^@\S+/]
		if username
			username = username[1..-1]
			user_replied_to = User.find_by(username: username)
			self.in_reply_to = user_replied_to.id if user_replied_to
		end
	end


end

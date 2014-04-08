class Message < ActiveRecord::Base

	belongs_to :user
	belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
	validates :user_id, presence: true
	validates :receiver_id, presence: { message: " username not found" }
	VALID_CONTENT_REGEX = /\Ad\s+@[\w\-.]+/
	validates :content, presence: true, length: { maximum: 140 }

	default_scope { order 'messages.created_at DESC'}
end

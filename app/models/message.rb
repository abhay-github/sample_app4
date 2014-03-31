class Message < ActiveRecord::Base

	belongs_to :user
	belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
	validates :user_id, presence: true
	validates :receiver_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
end

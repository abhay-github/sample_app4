class User < ActiveRecord::Base

	has_many :microposts, dependent: :destroy
	has_many :messages, dependent: :destroy
	has_many :received_msgs, class_name: "Message", dependent: :destroy, foreign_key: "receiver_id"
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relationships, source: :follower


  	before_validation { self.username.strip! }
	before_save	do |user|
		user.email = user.email.downcase
		user.username = user.username.downcase
	end
	before_create :create_remember_token

	validates :name, presence: true, length: {maximum: 50}

  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	VALID_USERNAME_REGEX = /\A[\w\-.]+\z/

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    
    validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_USERNAME_REGEX,
     			message: "can only contain letters, numbers, or any of these: underscore, hyphen, dot" },
     			length: {minimum: 3}

 	has_secure_password

 	validates :password, length: { minimum: 6 }

 	def User.new_remember_token
 		SecureRandom.urlsafe_base64
 	end

 	def User.hash(token)
 		Digest::SHA1.hexdigest(token.to_s)
 	end

 	def msg_feed
 		
 	end

 	def feed
 		Micropost.from_users_followed_by(self)
 	end

 	def following?(other_user)
 		self.relationships.find_by(followed_id: other_user.id)
 	end

 	def follow!(other_user)
 		self.relationships.create!(followed_id: other_user.id)
 		# send email to the other_user
 		UserMailer.follower_notification.deliver
 	end

 	def unfollow!(other_user)
 		self.relationships.find_by(followed_id: other_user.id).destroy
 	end

 	private

 		def create_remember_token
 			self.remember_token =  User.hash(User.new_remember_token)
 		end
end

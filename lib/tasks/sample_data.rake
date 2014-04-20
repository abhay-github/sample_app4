namespace :db do
	desc	"Fill database with sample data"
	task populate: :environment do
		make_users
		make_messages
		make_microposts
		make_relationships
	end
end


def make_users
	User.create!(name: "Example User", username: "exampleuser", email: "example@railstutorial.org",
				 password: "foobar", password_confirmation: "foobar",
				 admin: true, activated_state: true)
	99.times do |n|
		name = Faker::Name.name
		username = Faker::Internet.user_name(name)
		email = "example-#{n+1}@railstutorial.org"
		password = "foobar"
		User.create!(name: name, username: username, email: email, password: password,
					 password_confirmation: password, activated_state: true)
	end
end

def make_microposts
	users = User.all(limit: 6)
	50.times do 
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	users = User.all
	user = users.first
	followed_users = users[2..50]	
	followers = users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each { |follower| follower.follow!(user) }
end

def make_messages
	users = User.all(limit: 6)
	2.times do
		
		users.each do |user|
			rcpnt = User.find(rand(1..6))
			content = "@#{rcpnt.username} " + Faker::Lorem.sentence(3)
			# content =  + content
			user.messages.create!(content: content, receiver: rcpnt)
		end
	end
end
FactoryGirl.define do
	factory :user, :aliases => [:receiver] do
		sequence(:name)	{ |n| "Person #{n}"}
		sequence(:username) { |n| "person_#{n}"}
		sequence(:email) { |n| "person_#{n}@example.com"}	
		password "foobar"
		password_confirmation "foobar"
		activated_state true

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		sequence(:content) { Faker::Lorem.sentence(5) }
		user
	end

	factory :message do
		user
		receiver
		sequence(:content) { "@#{receiver.username} " + Faker::Lorem.sentence(5) }
	end
end
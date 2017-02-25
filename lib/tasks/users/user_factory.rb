require 'pry'
require 'faker'

module UserFactory
	
	def self.create_users number
		pp 'HELLO WORLD  yep'
		number = 50 unless number
		number.times do 
			User.create! email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: 'password'
		end
	end
end


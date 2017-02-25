require 'pry'
require 'faker'

module MessageFactory
	def self.create_messages num
		print 'inside create_messages method'
		num = 100 unless num
		num.times do
			t = Topic.all.sample
			u = User.all.sample
			Message.create! topic_id: t.id, user_id: u.id, subject: t.name, body: Faker::Lorem.paragraph(2, true, 4)
		end
	end
end


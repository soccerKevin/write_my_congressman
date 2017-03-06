require 'pp'
require 'pry'
Dir['./lib/tasks/**/*.rb'].each{ |file| require file }

namespace :messages do
	
	num = ARGV[1].to_i || 100

  task create: :environment do
		Rake.application['users:create'].invoke unless User.first
		create_topics unless Topic.first
    create_messages num
  end

  task reset: :environment do
    Message.destroy_all
    create_messages num
  end
end

def create_messages num 
	MessageFactory.create_messages num
end

def create_topics 
	Topic.create! name: 'Environment'	
	Topic.create! name: 'Trump Impeachment'	
	Topic.create! name: 'Business in Politics'	
end

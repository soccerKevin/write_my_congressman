require 'pp'
require 'pry'
Dir['./lib/tasks/**/*.rb'].each{ |file| require file }

namespace :messages do

  task create: :environment do
		create_users
		create_topics
    create_messages
  end

  task reset: :environment do
		User.destroy_all
		Topic.destroy_all
    Message.destroy_all
    create_messages
  end
end

def create_messages 
	MessageFactory.create_messages 100
end

def create_users
	UserFactory.create_users 50
end

def create_topics 
	Topic.create! name: 'Environment'	
	Topic.create! name: 'Trump Impeachment'	
	Topic.create! name: 'Business in Politics'	
end

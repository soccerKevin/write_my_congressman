
require 'pp'
require 'pry'

namespace :messages do
  task create: :environment do
    create_messages
  end

  task reset: :environment do
    Message.destroy_all
    create_messages
  end
end

def create_messages 
	print 'inside create_messages method'
	create_topics
	Message.new topic_id: Topics.all.sample.id, user_id: User.all.sample.id, subject: 'Fake subject', body: 'fake text for the body'
end


def create_topics 
	print 'inside create_topics'
	Topic.create! name: 'Environment'	
	Topic.create! name: 'Trump Impeachment'	
	Topic.create! name: 'Business in Politics'	
end

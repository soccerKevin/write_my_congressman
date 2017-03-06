require 'pp'
require 'pry'
Dir['./lib/tasks/**/*.rb'].each{ |file| require file }

namespace :users do

	num = ARGV[1].to_i || 100
	
  task create: :environment do
		create_topics unless Topic.first
    create_users num 
  end

  task reset: :environment do
    User.destroy_all
    create_users num 
  end
end

def create_users num 
	UserFactory.create_users num
end

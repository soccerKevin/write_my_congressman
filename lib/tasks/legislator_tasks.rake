require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }

namespace :legislators do
  task create: :environment do
    create_legislators
  end

  task reset: :environment do
    Legislator.destroy_all
    create_legislators
  end
end

def create_legislators
  legislator_file = './db/raw/legislators-current.yaml'
  social_file = './db/raw/legislators-social-media.yaml'
  LegislatorFactory.legislators_from_yaml legislator_file, social_file
end

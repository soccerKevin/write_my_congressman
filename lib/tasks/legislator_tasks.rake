# alias :orig_require :require
# def require s
#   if orig_require s
#     print "Requires #{s}\n"
#   else
#     print "tried to get #{s}\n"
#   end
# end

require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }

task create_legislators: :environment do
  create_legislators
end

task reset_legislators: :environment do
  Legislator.destroy_all
  create_legislators
end

def create_legislators
  legislator_file = './db/raw/legislators-current.yaml'
  social_file = './db/raw/legislators-social-media.yaml'
  LegislatorFactory.legislators_from_yaml legislator_file, social_file
end

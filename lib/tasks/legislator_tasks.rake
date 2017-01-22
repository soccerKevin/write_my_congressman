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
  legislator_file = './db/raw/legislators-current.yaml'
  social_file = './db/raw/legislators-social-media.yaml'
  Legislators.create_from_yaml legislator_file, social_file
end

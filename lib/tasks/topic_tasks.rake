require 'pp'
require 'pry'

namespace :topics do
  task csv: :environment do
    # topics = CSV.read('./notes/topics.txt')
    topics = CSV.read('./db/raw/topics.csv')
    binding.pry
  end
end

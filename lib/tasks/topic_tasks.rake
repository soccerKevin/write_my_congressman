require 'pp'
require 'pry'

namespace :topics do
  task csv: :environment do
    # topics = CSV.read('./notes/topics.txt')
    binding.pry
    topics = CSV.read('./db/raw/topics.csv')
  end
end

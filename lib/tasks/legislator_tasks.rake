require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }
Dir['./lib/scrapers/*.rb'].each{ |file| require file }

namespace :legislators do
  task create: :environment do
    create_legislators
  end

  task reset: :environment do
    Legislator.destroy_all
    create_legislators
  end

  task find_images: :environment do
    find_images
  end

  task image_count: :environment do
    pp Dir['./db/raw/images/*'].count
  end
end

def create_legislators
  legislator_file = './db/raw/legislators-current.yaml'
  social_file = './db/raw/legislators-social-media.yaml'
  LegislatorFactory.legislators_from_yaml legislator_file, social_file
  find_images
end

def find_images
  scraper = WikipediaScraper::LegislatorImages.new 'db/raw/images/'
  failed = []
  Legislator.all.each do |legislator|
    l_name = "#{legislator.first_name} #{legislator.first_name}"
    wiki = legislator.wikipedia
    begin
      scraper.get_legislator l_name, wiki
      pp l_name
    rescue Exception => e
      binding.pry
      failed.push l_name
    end
  end

  pp failed
end

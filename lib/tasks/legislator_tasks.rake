require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }
Dir['./lib/scrapers/*.rb'].each{ |file| require file }
Dir['./lib/vendor_api/*.rb'].each{ |file| require file }

@legislator_image_path = 'db/raw/images/legislators'
@legislator_file = './db/raw/legislators-current.yaml'
@social_file = './db/raw/legislators-social-media.yaml'

namespace :legislators do
  task create: :environment do
    create_legislators
  end

  task reset: :environment do
    Legislator.destroy_all
    create_legislators
  end

  task :find_images, [:replace] => :environment do |t, args|
    find_images args[:replace]
  end

  task image_count: :environment do
    pp Dir['./db/raw/images/*'].count
  end

  task :missing, [:key1, :key2] => :environment do |t, args|
    legislators = YAML.load_file @legislator_file
    "missing: #{args[:missing]}"
    matching = legislators.select do |l|
      next l[args[:key1]].nil? unless args[:key2]
      l[args[:key1]][args[:key2]].nil?
    end
    count = matching.count
    names = matching.map{ |l| l['name']['official_full'] }
    pp names, count
  end

  task all_form_fields: :environment do
    bio_ids = Legislator.all.map{ |l| l[:bio_id] }[0...-1]
    topics = bio_ids.each_slice(10).map do |ids|
      VendorAPI::CongressForms.get_elements_hash ids
    end.map{ |t| t.to_h.values }.flatten.uniq.join(',')
    File.open("./notes/topics.txt", 'w'){ |f| f.write topics }
  end
end

def create_legislators
  LegislatorFactory.legislators_from_yaml @legislator_file, @social_file
end

def find_images(replace = false)
  skip_saved = !replace
  scraper = WikipediaScraper::LegislatorImages.new @legislator_image_path
  failed = []
  Legislator.all.each do |legislator|
    next if skip_saved && has_image?(legislator)
    l_name = legislator.name
    wiki = legislator.wikipedia
    begin
      scraper.get_legislator l_name, wiki
      pp l_name
    rescue Exception => e
      failed.push l_name
    end
  end

  pp failed
end

def has_image?(legislator)
  l_name = legislator.name.downcase.gsub(' ', '_')
  Dir["./#{@legislator_image_path}/*"].any?{ |img| img.include? l_name }
end

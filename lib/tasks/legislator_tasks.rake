require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }
Dir['./lib/scrapers/*.rb'].each{ |file| require file }
Dir['./lib/vendor_api/*.rb'].each{ |file| require file }
Dir['./lib/vendor_api/microsoft/*.rb'].each{ |file| require file }

@raw_image_path = 'db/raw/images/legislators'
@asset_image_path = './app/assets/images/legislators'
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

  task crop_images: :environment do
    crop_images
  end
end

def create_legislators
  LegislatorFactory.legislators_from_yaml @legislator_file, @social_file
end

def has_image?(legislator)
  l_name = legislator.name.downcase.gsub(' ', '_')
  Dir["./#{@raw_image_path}/*"].any?{ |img| img.include? l_name }
end

def find_images(replace = false)
  skip_saved = !replace
  scraper = WikipediaScraper::LegislatorImages.new @raw_image_path
  failed = []
  complete = []
  Legislator.all.each do |legislator|
    next if skip_saved && has_image?(legislator)
    l_name = legislator.name
    wiki = legislator.wikipedia
    begin
      response = scraper.get_legislator l_name, wiki
      complete.push response
      pp l_name
    rescue Exception => e
      failed.push l_name
    end
  end

  File.open('./db/raw/legislator-images.yml', 'w'){ |f| f.write complete.to_yaml }
  pp failed
end

def crop_images
  save_path = @asset_image_path
  YAML.load_file('./db/raw/legislator-images.yml').each do |image|
    face_info = VendorAPI::Microsoft::Face.face_attributes image[:src]
    binding.pry
  end
end

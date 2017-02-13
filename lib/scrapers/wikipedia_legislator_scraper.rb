require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'human_name_parser'

module WikipediaScraper
  class LegislatorImages
    ROOT = 'https://en.wikipedia.org'

    def initialize
      get_page
      save_images 'db/raw/images/'
    end

    def get_page
      @agent = Mechanize.new
      @page = @agent.get "#{ROOT}/wiki/Current_members_of_the_United_States_House_of_Representatives"
    end

    def legislators
      legs = @page.css 'table:eq(6) td[nowrap]'
      failed = []

      legislators = legs.map do |l|
        begin
          url = parse_image_url l.children.first.children.first.attributes['src'].value
          l_name = l.children.last.children.first.children.first.attributes['title'].value
          idx = l_name.index '('
          l_name = l_name[0...(idx - 1)] if idx
          l_name = HumanNameParser.parse l_name
          { name: "#{l_name.first} #{l_name.last}", url: url }
        rescue Exception => e
          failed.push l.children.last.children.first.children.first.attributes['title'].value
          next nil
        end.compact
      end
      pp "grabbed #{legislators.count} legislator pictures"
      pp "failed to grab: ", failed
      legislators
    end

    def parse_image_url(start_url)
      r_index = start_url.rindex '/'
      url = start_url[2...r_index].gsub '/thumb', ''
      "https://#{url}"
    end

    def save_images(path)
      pp "", "SAVING IMAGES"

      failures = []
      legislators.each do |leg|
        begin
          image = open "#{leg[:url]}"
          File.open("#{Rails.root}/#{path}/#{leg[:name]}.jpg","wb"){ |file| file.puts image.read }
          pp leg[:name]
        rescue Exception => e
          failures.push leg
        end
      end
      pp "failures: ", failures
    end

    def save_first(path, count=1)
      open image_urls.first(count).first do |image|
        File.open("#{Rails.root}/#{path}/#{@subject}","wb"){ |file| file.puts image.read }
      end
    end
  end
end

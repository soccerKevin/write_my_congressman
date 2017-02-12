require 'nokogiri'
require 'open-uri'
require 'mechanize'

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
      anchors = @page.css('table:eq(6) a.image img')
      names = @page.css('table:eq(6) .vcard a').map{ |a| a.text.split(' ').join('_') }

      imgs ||= anchors.map do |img_a|
        start_url = img_a.attributes['src'].value
        r_index = start_url.rindex '/'
        url = start_url[2...r_index].gsub '/thumb', ''
        "https://#{url}"
      end

      legislators = names.zip(imgs).map{ |l| {name: l.first, url: l.last} }
    end

    def save_images(path)
      legislators.each do |leg|
        image = open "#{leg[:url]}"
        File.open("#{Rails.root}/#{path}/#{leg[:name]}.jpg","wb"){ |file| file.puts image.read }
      end
    end

    def save_first(path, count=1)
      open image_urls.first(count).first do |image|
        File.open("#{Rails.root}/#{path}/#{@subject}","wb"){ |file| file.puts image.read }
      end
    end
  end
end

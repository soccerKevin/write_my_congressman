require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'human_name_parser'

module WikipediaScraper
  class LegislatorImages
    ROOT = 'https://en.wikipedia.org/wiki'
    FILES_REGEX = /\.(jpg|jpeg|gif|png)/

    def initialize(save_path)
      @agent = Mechanize.new
      @save_path = save_path
    end

    def get_legislator(l_name, wiki)
      slug = slugify_wiki wiki
      page = @agent.get "#{ROOT}/#{slug}"
      img_src = image_from_page page
      src = parse_src img_src
      fetch_and_save l_name, src
    end

    def fetch_and_save(l_name, src)
      image = open src
      l_n = l_name.downcase.gsub(' ', '_').gsub '.',''
      file_name = "#{l_n}.jpg"
      File.open("#{Rails.root}/#{@save_path}/#{file_name}","wb"){ |file| file.puts image.read }
    end

    def parse_src(start_url)
      two_extensions = start_url.downcase.scan(FILES_REGEX).size > 1
      r_index = two_extensions ? start_url.rindex('/') : start_url.length
      url = start_url[2...r_index].gsub '/thumb', ''
      "https://#{url}"
    end

    def image_from_page(page)
      subtitles = page.css '#mw-content-text > p'
      raise 'Image Not found' if subtitles.any? && subtitles.first.text.include?('may refer to:')
      page.css('.infobox.vcard a.image img').first.attributes['src'].value
    end

    def slugify_wiki(wiki)
      wiki.gsub ' ', '_'
    end
  end
end

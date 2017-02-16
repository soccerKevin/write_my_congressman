require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'human_name_parser'

module WikipediaScraper
  class LegislatorImages
    ROOT = 'https://en.wikipedia.org/wiki'

    def initialize(save_path)
      @agent = Mechanize.new
      @save_path = save_path
    end

    def get_legislator(l_name, wiki)
      slug = slugify_wiki wiki
      page = get_page "#{ROOT}/#{slug}"
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
      files_regex = /\.(jpg|jpeg|gif|png)/
      two_extensions = start_url.downcase.scan(files_regex).size > 1
      r_index = two_extensions ? start_url.rindex('/') : start_url.length
      url = start_url[2...r_index].gsub '/thumb', ''
      "https://#{url}"
    end

    def image_from_page(page)
      page.css('.infobox.vcard a.image img').first.attributes['src'].value
    end

    def get_page(url)
      page = @agent.get url
      subtitles = page.css '#mw-content-text > p'
      raise 'Not found' if subtitles.any? && subtitles.first.text.include?('may refer to:')
      page
    end

    def slugify_name(l_name)
      n = HumanNameParser.parse l_name
      s1 = n.to_s.gsub ' ', '_'
      s2 = "#{s1}_(politician)"
      s3 = "#{n.first}_#{n.last}"
      [s1, s2, s3]
    end

    def slugify_wiki(wiki)
      wiki.gsub ' ', '_'
    end
  end
end

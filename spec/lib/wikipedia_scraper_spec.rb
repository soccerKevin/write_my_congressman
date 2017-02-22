require_relative 'lib_helper'
LegislatorImages = WikipediaScraper::LegislatorImages

RSpec.describe LegislatorImages do
  include ResponseStubber

  def stubbed_response
    @stubbed_response ||= fixture('wikipedia_legislator_response.html')
  end

  def page
    Nokogiri::XML open "#{::Rails.root.join}/spec/fixtures/wikipedia_legislator_response.html"
  end

  before :each do
    stub_html_response stubbed_response
    @scraper = LegislatorImages.new '/test'
  end

  it 'finds image extensions' do
    expect('.jpg.png.gif.png'.downcase.scan(LegislatorImages::FILES_REGEX).length).to be 4
  end

  it 'slugifies the wiki' do
    wiki = 'Mike Johnson (Oklahoma politician)'
    slug = @scraper.slugify_wiki wiki
    expect(slug).to eq 'Mike_Johnson_(Oklahoma_politician)'
  end

  it 'finds the image' do
    image_src = @scraper.image_from_page page
    expect(image_src.include?('Patty_Murray%2C_official_portrait')).to be true
  end

  it 'parses the image source' do
    image_src = @scraper.image_from_page page
    src = @scraper.parse_src image_src
    expect(src.eql?('https://upload.wikimedia.org/wikipedia/commons/4/4f/Patty_Murray%2C_official_portrait%2C_113th_Congress.jpg')).to be true
  end
end

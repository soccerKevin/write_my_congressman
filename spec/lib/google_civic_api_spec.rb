require_relative 'lib_helper'

def stubbed_response
  @stubbed_response ||= fixture('google_civic_response.json')
end

def json_response
  JSON.parse stubbed_response
end

Officials = VendorAPI::GoogleCivic::Officials
RSpec.describe Officials do
  include ResponseStubber

  before :all do
    @address = "465 Andover Court, Gurnee, IL 60031"
    @whitelisted_names = ["Donald J. Trump", "Mike Pence", "Tammy Duckworth", "Richard J. Durbin", "Bradley Scott Schneider"]

    class Officials
      @@ROOT = 'https://www.test.com/'
    end
  end

  before :each do
    stub_json_response stubbed_response
  end

  describe 'get methods:' do
    it 'get_from_address' do
      response = Officials.get_from_address @address
      expect(response.parsed_response).to eq json_response
    end

    it 'whitelisted_legislators' do
      response = Officials.whitelisted_legislators @address
      json = json_response['officials'].select do |official|
        @whitelisted_names.include? official['name']
      end
      expect(response).to eq json
    end

    it 'names_from_address' do
      response = Officials.names_from_address @address
      expect(response).to eq @whitelisted_names
    end
  end

  describe 'sanitize_address' do
    it 'should handle a proper string address' do
      address = Officials.send :sanitize_address, @address
      expect(address.class.name).to eq "StreetAddress::US::Address"
    end

    it 'should handle a StreetAddress' do
      address = Officials.send :sanitize_address, StreetAddress::US.parse(@address)
      expect(address.class.name).to eq "StreetAddress::US::Address"
    end

    it 'should not allow anything else' do
      begin
        Officials.send :sanitize_address, "Teenage Mutant Ninja Turtles, Turtles in a half shell"
        fail
       rescue
        pass
      end
    end
  end
end

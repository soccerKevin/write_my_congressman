require 'rails_helper'
require_relative 'lib_helper'
require 'webmock/rspec'

Officials = VendorAPI::GoogleCivic::Officials

def stub_requests
  stub_request(:get, /www.test.com/).
    with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
    to_return body: stubbed_response, headers: { content_type: 'application/json'
    }
end

def stubbed_response
  @stubbed_response ||= fixture('google_civic_response.json')
end

def json_response
  JSON.parse stubbed_response
end

RSpec.describe Officials do
  before :each do
    stub_requests
    @address = "465 Andover Court, Gurnee, IL 60031"
    @whitelisted_names = ["Donald J. Trump", "Mike Pence", "Tammy Duckworth", "Richard J. Durbin", "Bradley Scott Schneider"]

    class Officials
      @@ROOT = 'https://www.test.com/'
    end
  end

  describe 'get methods' do
    it 'get_from_address' do
      response = Officials.get_from_address(@address)
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

    end
  end

  it 'whitelist_legislators' do
  end
end

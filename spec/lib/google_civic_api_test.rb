require 'rails_helper'
require_relative 'lib_helper'
require 'webmock/rspec'
Officials = VendorAPI::GoogleCivic::Officials

def stub_requests
  stub_request(:get, /www.test.com/).
    with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
    to_return(status: 200, body: stubbed_response, headers: {})
end

def stubbed_response
  @stubbed_response ||= fixture 'google_civic_response.json'
end

RSpec.describe Officials do
  before :each do
    stub_requests
    @address = "465 Andover Court, Gurnee, IL 60031"

    class Officials
      @@ROOT = 'https://www.test.com/'
    end

  end

  it "should do something" do
    pp Officials.get_from_address @address
  end
end

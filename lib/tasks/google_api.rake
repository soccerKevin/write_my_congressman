require 'pp'
require 'pry'
require 'httparty'
require 'street_address'
require_relative '../vendor_api/google_civic_api.rb'

namespace :google_civic do
  task :get_address, [:address] => :environment do |t, args|
    include VendorAPI
    address = args[:address]
    address ||= "465 Andover Court, Gurnee, IL 60031"
    street_address = StreetAddress::US.parse address
    pp GoogleCivic::Officials.names_from_address street_address
  end


  task update_fixtures: :environment do
    include VendorAPI
    address ||= "465 Andover Court, Gurnee, IL 60031"
    response = GoogleCivic::Officials.get_from_address(address).to_s.gsub '=>', ':'
    File.open('./spec/fixtures/google_civic_response.json', 'w'){ |f| f.write response }
  end
end

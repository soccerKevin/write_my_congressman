require 'pp'
require 'pry'
require 'httparty'
require 'street_address'
require_relative '../vendor_api/google_civic_api.rb'

task :get_address => :environment do
  include VendorAPI
  address = StreetAddress::US.parse("14531 31st ave ne Seattle, WA, 98155")
  GoogleCivic.get_from_address address
end

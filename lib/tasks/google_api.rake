require 'pp'
require 'pry'
require 'httparty'
require 'street_address'
require_relative '../vendor_api/google_civic_api.rb'

namespace :google_civic
  task :get_address, [:address] => :environment do |t, args|
    include VendorAPI
    address = args[:address]
    address ||= "465 Andover Court, Gurnee, IL 60031"
    street_address = StreetAddress::US.parse address
    pp GoogleCivic::Officials.names_from_address street_address
  end


  task update_fixtures: :envoronment do
    api_key = Rails.application.secrets.google_civics_api_key
    root = 'https://www.googleapis.com/civicinfo/v2'
    response = HTTParty.get "#{@@ROOT}/representatives?#{query}"
    File.open('./spec/fixtures/google_civic_response.json', 'w'){ |f| f.write response }
  end
end

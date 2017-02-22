Dir['./lib/vendor_api/*'].each{ |file| require file }
Dir['./lib/scrapers/*'].each{ |file| require file }
require 'rails_helper'
require_relative 'response_stubber'

require 'phone'
require 'pry'

class Phone < ActiveRecord::Base
  Phoner::Phone.default_country_code = '1'
  validate :validate_number

  def validate_number
    raise "Invalid Phone Number" unless Phoner::Phone.valid? number
  end
end

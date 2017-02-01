require 'phone'
require 'pry'

class Phone < ActiveRecord::Base
  belongs_to :legislator

  validate :validate_number

  Phoner::Phone.default_country_code = '1'

  def validate_number
    raise "Invalid Phone Number" unless Phoner::Phone.valid? number
  end
end

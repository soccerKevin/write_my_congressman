require 'phone'
require 'pry'

class Phone < ActiveRecord::Base
  Phoner::Phone.default_country_code = '1'
  validate :phoner_validate

  def phoner_validate
    Phoner::Phone.valid? number
  end
end

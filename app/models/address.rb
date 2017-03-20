require 'pry'

class Address < ActiveRecord::Base
  include ActiveModel::Validations
  has_paper_trail

  belongs_to :legislator
  belongs_to :user

  validates_presence_of :line, :city, :state, :zip

  class << self
    def from_line(address)
      a = address.is_a?(StreetAddress::US::Address) ? address : StreetAddress::US.parse(address)
      raise TypeError if a.blank?
      Address.new({
        line: a.line1,
        city: a.city,
        state: a.state,
        zip: a.postal_code
      })
    rescue Exception => e
      raise e.is_a?(TypeError) ? ArgumentError.new("Could not parse address") : e
    end

    alias :from_street_address :from_line
  end

  def legislators
    begin
      sa = street_address
    rescue
      return []
    end
    require "#{Rails.root}/lib/vendor_api/google_civic_api"
    legislator_names = VendorAPI::GoogleCivic::Officials.names_from_address sa
    last_names = legislator_names.map{ |name| name.split(' ').last }
    @legislators = Legislator.where(last_name: last_names)
  end

  def street_address
    @street_address ||= StreetAddress::US.parse "#{line}, #{city}, #{state} #{zip}"
  end

end

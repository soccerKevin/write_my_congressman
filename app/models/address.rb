class Address < ActiveRecord::Base
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
end

require 'street_address'

module VendorAPI
  module GoogleCivic
    class Officials
      @@KEY = Rails.application.secrets.google_civics_api_key
      @@ROOT = 'https://www.googleapis.com/civicinfo/v2'
      @@WHITELISTED_OFFICES = ['senate', 'house', 'whitehouse']

      class << self
        def get_from_address(address)
          address = sanitize_address address
          query = { address: address.to_s, key: @@KEY }.to_query
          HTTParty.get "#{@@ROOT}/representatives?#{query}"
        end

        def whitelisted_legislators(address)
          whitelist_legislators get_from_address address
        end

        def names_from_address(address)
          officials = whitelist_legislators get_from_address address
          names = officials.map{ |official| official['name'] }
        end

      private

        def sanitize_address(address)
          address.is_a?(StreetAddress::US::Address) ? address : StreetAddress::US.parse(address)
        rescue Exception => e
          raise e.is_a?(TypeError) ? ArgumentError.new("argument must be an instance of StreetAddress") : e
        end

        def whitelist_legislators(response)
          officials = response['officials'].select do |official|
            @@WHITELISTED_OFFICES.map do |office|
              next unless official['urls']
              official['urls'].first.include? office
            end.include? true
          end
        end
      end
    end
  end
end

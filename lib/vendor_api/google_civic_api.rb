require 'street_address'
require_relative 'api'

module VendorAPI
  module GoogleCivic
    class Officials < API
      @@KEY = Rails.application.secrets.google_civics_api_key
      @@ROOT = 'https://www.googleapis.com/civicinfo/v2'
      @@WHITELISTED_OFFICES = ['senate', 'house', 'whitehouse']

      class << self
        def get_from_address(address)
          address = sanitize_address address
          path = '/representatives'
          get path, address: address
        end

        def whitelisted_legislators(address)
          whitelist_legislators get_from_address address
        end

        def names_from_address(address)
          whitelist_legislators(get_from_address(address)).map{ |official| official['name'] }
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

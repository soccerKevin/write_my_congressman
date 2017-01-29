

module VendorAPI
  class GoogleCivic
    @@KEY = Rails.application.secrets.google_civics_api_key
    @@ROOT = 'https://www.googleapis.com/civicinfo/v2'

    class << self
      def get_from_address(address)
        address = sanitize_address address
        query = { address: address.to_s, key: @@KEY }.to_query
        response_names HTTParty.get "#{@@ROOT}/representatives?#{query}"
      end

    private

      def sanitize_address(address)
        StreetAddress::US.parse address unless address.is_a? StreetAddress::US::Address
      rescue Exception => e
        raise e.is_a?(TypeError) ? ArgumentError.new("argument must be an instance of StreetAddress") : e
      end

      def response_names(response)
        offices = ['senate', 'house', 'whitehouse']
        officials = response['officials'].select do |official|
          offices.select do |office|
            next unless official['urls']
            official['urls'].first.include? office rescue binding.pry
          end
        end
        names = response['officials'].map{ |official| official['name'] }
      end
    end
  end
end

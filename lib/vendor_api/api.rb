module VendorAPI
  class API
    @@ROOT = 'www.example.com'
    @@KEY = 'user_key'
    @@KEY_NAME = 'key'

    class << self
      def get(path, query_hash)
        query_hash[@@KEY_NAME.downcase.to_sym] = @@KEY if @@KEY_NAME && @@KEY
        HTTParty.get "#{@@ROOT}#{path}?#{query_hash.to_query}"
      end

      def post(path, **options)
        HTTParty.post "#{@@ROOT}#{path}", headers: options[:headers], body: options[:body], query: options[:query], debug_output: $stdout
      end

    private

      def sanitize_address(address)
        address.is_a?(StreetAddress::US::Address) ? address : StreetAddress::US.parse(address)
      rescue Exception => e
        raise e.is_a?(TypeError) ? ArgumentError.new("argument must be an instance of StreetAddress") : e
      end
    end
  end
end

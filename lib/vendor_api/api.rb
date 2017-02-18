module VendorAPI
  class API
    @@ROOT = 'www.example.com'
    @@KEY = 'user_key'
    @@KEY_NAME = 'key'

    class << self
      def get(path, query_hash)
        query_hash[@@KEY_NAME.downcase.to_sym] = @@KEY
        HTTParty.get "#{@@ROOT}#{path}?#{query_hash.to_query}"
      end

      def post(path, headers: h, body: b, query: q)
        HTTParty.post "#{@@ROOT}#{path}#{query}", headers: headers, body: body
      end

    protected

      def sanitize_address(address)
        address.is_a?(StreetAddress::US::Address) ? address : StreetAddress::US.parse(address)
      rescue Exception => e
        raise e.is_a?(TypeError) ? ArgumentError.new("argument must be an instance of StreetAddress") : e
      end

      def default_query; {}; end
      def q(**fields)
        query = Rack::Utils.build_query default_query.merge fields
        query.blank? ? "" : "?#{query}"
      end

      def default_body; {}; end
      def b(**options)
        default_body.merge(options).to_json
      end


      def default_headers; {}; end
      def h(**options)
        default_headers.merge options
      end
    end
  end
end

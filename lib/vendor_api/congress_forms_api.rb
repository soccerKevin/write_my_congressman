# sh "curl -H \"Content-Type: application/json\" -d '{\"bio_ids\": #{bio_ids}}' https://congressforms.eff.org/retrieve-form-elements"
require 'pry'
require_relative 'api'

module VendorAPI
  class CongressForms < API
    @@ROOT = 'https://congressforms.eff.org'
    @@KEY = nil
    @@KEY_NAME = nil

    class << self
      def get_form_elements(bio_ids)
        path = '/retrieve-form-elements'
        # headers = { 'Content-Type': 'application/json' }
        headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
        body = { 'bio_ids' => bio_ids }
        response = post path, headers: headers, body: body
        topics = response.map{ |r| r.last['required_actions'].last['options_hash'] }
        array1 = topics.select{ |t| t.class == Hash }.map{ |h| h.keys }.flatten
        array2 = topics.select{ |t| t.class == Array }.flatten
        topic_names = array1.concat(array2).uniq
      rescue
        return []
      end
    end
  end
end

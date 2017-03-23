# sh "curl -H \"Content-Type: application/json\" -d '{\"bio_ids\": #{bio_ids}}' https://congressforms.eff.org/retrieve-form-elements"
require 'pry'
require_relative 'api'

module VendorAPI
  class CongressForms < API
    @@ROOT = 'https://congressforms.eff.org'
    @@KEY = nil
    @@KEY_NAME = nil

    class << self
      def get_form(bio_ids)
        path = '/retrieve-form-elements'
        headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
        body = { 'bio_ids' => [bio_ids].flatten }
        response = post path, headers: headers, body: body
      end

      def get_form_topics(bio_ids)
        response = get_form bio_ids
        topics = response.map{ |r| r.last['required_actions'].last['options_hash'] }
        array1 = topics.select{ |t| t.class == Hash }.map{ |h| h.keys }.flatten
        array2 = topics.select{ |t| t.class == Array }.flatten
        topic_names = array1.concat(array2).uniq
      rescue
        return []
      end

      def fill_out_form()

      end

      def get_elements_hash(bio_ids)
        get_form(bio_ids).map do |k,v|
          begin
            topics = v['required_actions'].select{|field| field['value'].downcase.include?('topic') }.first['options_hash']
            t = (topics.class == Hash ? topics.keys : topics).flatten
          rescue Exception => e
            t = nil
          end
          [k, t]
        end
      end
    end
  end
end

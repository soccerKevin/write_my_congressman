# sh "curl -H \"Content-Type: application/json\" -d '{\"bio_ids\": #{bio_ids}}' https://congressforms.eff.org/retrieve-form-elements"
require 'pry'
require_relative 'api'

module VendorAPI
  class CongressForm < API
    @@ROOT = 'https://congressforms.eff.org'
    @@KEY = nil
    @@KEY_NAME = nil

    def initialize(bio_id)
      r = self.class.get_form bio_id
      raise "Cannot find form" if r.empty?
      @bio_id = r.keys.first
      @fields = r.first.last['required_actions']
    end

    def send_form(bio_id, form)

    end

    def field_names
      @fields.map{ |f| f['value'].slice(1..-1).downcase }
    end

    def field_options(field_name)
      options = field(field_name)['options_hash']
      options.is_a?(Hash) ? options.keys : options
    end

    def field(name)
      @fields.select{ |field| field['value'].downcase.include? name.downcase }.first
    end

    def send_out(completed_form)
      self.class.send_form @bio_id, completed_form
    end

    class << self
      def get_form(bio_ids)
        path = '/retrieve-form-elements'
        headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
        body = { 'bio_ids' => [bio_ids].flatten }
        response = post path, headers: headers, body: body
      end

      def send_form(bio_id, completed_fields)
        path = '/fill-out-form'
        headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
        fields = format_field_keys completed_fields
        body = { 'bio_id' => bio_id, fields: fields }
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

      def format_field_keys(fields)
        fields.map do |key, value|
          formatted_key = key.upcase
          formatted_key.prepend('$') unless formatted_key.first == '$'
          [formatted_key, value]
        end.to_h
      end

      def get_required_fields(bio_ids)
        get_form(bio_ids).map{ |k,v| v['required_actions'] }
      end

      def get_topics(bio_ids)
        get_form(bio_ids).map do |k,v|
          begin
            topics = v['required_actions'].select{ |field| field['value'].downcase.include?('topic') }.first['options_hash']
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

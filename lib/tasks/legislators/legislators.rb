require 'yaml'

module Legislators
  class << self
    def create_from_yaml(main_path, social_path)
      raw = YAML.load_file main_path
      raw_social = YAML.load_file social_path\

      raw.map do |legislator_raw|
        thomas_id = legislator_raw['id']['thomas']
        legislator_raw['social'] = raw_social.detect{ |leg| leg['id']['thomas'] == '00136' }['social']
        Legislator.from_JSON legislator_raw
      end
    end
  end
end

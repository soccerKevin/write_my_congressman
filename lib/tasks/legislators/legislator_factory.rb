require 'yaml'
require 'pry'

module LegislatorFactory

  def self.legislators_from_yaml(main_path, social_path)
    raw = YAML.load_file main_path
    raw_social = YAML.load_file social_path

    raw.map do |legislator_raw|
      thomas_id = legislator_raw['id']['thomas']
      legislator_raw['social'] = raw_social.detect{ |leg| leg['id']['thomas'] == '00136' }['social']
      begin
        legislator_from_JSON legislator_raw
      rescue Exception => e
        pp "Legislator: #{legislator_raw['name']['first']} #{legislator_raw['name']['last']}"
        if e.to_s == "Could not parse address"
          pp "Address Error: #{legislator_raw['terms'].last['address']}"
        else
          pp e.to_s
        end
      end
    end
  end

  def self.legislator_from_JSON(json)
    ids = json['id']
    bio = json['bio']
    term = json['terms'].last
    address = Address.from_line term['address']
    phone = Phone.create!({number: term['phone']})
    begin
      fax = Phone.create!({number: term['fax']})
    rescue
      fax = nil
    end
    district = term['district'] if term['type'] = 'rep'
    social = json['social']

    Legislator.create!(
      #id
      bio_id: ids['bioguide'],
      # name
      first_name: json['name']['first'],
      last_name: json['name']['last'],
      # bio
      birthday: Date.parse(bio['birthday']),
      gender: bio['gender'],
      religion: bio['religion'],
      # term
      position: term['type'],
      party: term['party'],
      started: Date.parse(json['terms'].first['start']),
      state: term['end'],
      district: district,
      url: term['url'],
      address: address,
      phone: phone,
      fax: fax,
      contact_form_url: term['form'],
      # social
      twitter_name: social['twitter'],
      facebook_name: social['facebook'],
      facebook_id: social['facebook_id'],
      youtube_id: social['youtube_id'],
      twitter_id: social['twitter_id']
    )
  end
end

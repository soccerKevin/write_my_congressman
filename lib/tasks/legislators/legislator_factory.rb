require 'yaml'
require 'pry'

module LegislatorFactory

  def self.legislators_from_yaml(main_path, social_path)
    raw = YAML.load_file main_path
    raw_social = YAML.load_file social_path

    raw.map do |legislator_raw|
      thomas_id = legislator_raw['id']['thomas']
      social = raw_social.detect{ |leg| leg['id']['thomas'] == thomas_id }
      legislator_raw['social'] = social['social'] if social
      begin
        legislator_from_JSON legislator_raw
      rescue Exception => e
        pp "Legislator: #{legislator_raw['name']['official_full']}}"
        if e.to_s == "Could not parse address"
          pp "Address Error: #{legislator_raw['terms'].last['address']}"
        else
          pp e.to_s
        end
      end
    end
  end

  def self.executives_from_yaml(executive_path)
    executives = YAML.load_file(executive_path).last 2
  end

  def self.legislator_from_JSON(json)
    ids = json['id']
    l_name = json['name']
    bio = json['bio']

    term = json['terms'].last
    district = term['district'] if term['type'] == 'rep'

    address = Address.from_line term['address']
    phone = Phone.create!({number: term['phone']})
    fax = Phone.create!({number: term['fax']}) rescue fax = nil
    contact_form_url = term['contact_form'].nil? ? "#{term['url']}/contact" : term['contact_form']

    social = json['social']
    if social
      twitter_name = social['twitter'],
      facebook_name = social['facebook'],
      facebook_id = social['facebook_id'],
      youtube_id = social['youtube_id'],
      twitter_id = social['twitter_id']
    end

    Legislator.create!(
      #id
      bio_id: ids['bioguide'],
      wikipedia: ids['wikipedia'],
      # name
      first_name: l_name['first'],
      last_name: l_name['last'],
      official_name: l_name['official_full'],
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
      contact_form_url: contact_form_url,
      # social
      twitter_name: twitter_name,
      facebook_name: facebook_name,
      facebook_id: facebook_id,
      youtube_id: youtube_id,
      twitter_id: twitter_id
    )
  end
end

module Legislators
  module Email
    # List of the main topic names
    # keys = user's choice
    # values = match to email form subject
    TOPICS = {
      other: ['other', 'misc']
    }

    def self.user_options
      TOPICS.keys
    end

    def self.match_topic(message_topic, form_topics)
      possibles = TOPICS[message_topic.downcase.to_sym]
      possibles.select{ |pt| form_topics.map(&:downcase).any?{ |ft| ft.include? pt } }.first
    end
  end
end

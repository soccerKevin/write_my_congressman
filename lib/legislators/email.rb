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
  end
end

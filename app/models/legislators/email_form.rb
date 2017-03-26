module Legislators
  class EmailForm

    def initialize(message, legislator)
      @message = message
      @form = VendorAPI::CongressForm.new legislator.bio_id
    end

    def name_first(possibles)
      @message.first_name
    end

    def name_last(possibles)
      @message.last_name
    end

    def address_street(possibles)
      @message.address.street
    end

    def address_city(possibles)
      @message.address.city
    end

    def address_zip4(possibles)
      @message.address.zip_ext
    end

    def address_zip5(possibles)
      @message.address.zip_base
    end

    def email(possibles)
      @message.email
    end

    def phone(possibles)
      nil
    end

    def message(possibles)
      @message.body
    end

    def name_prefix(possibles)
      possibles.first
    end

    def address_county(possibles)
      nil
    end

    def topic(possibles)
      Legislators::Email.match_topic @message.subject, possibles
    end

    def address_state_postal_abbrev(possibles)
      @message.address.zip_base
    end

    def form_address_street_2(possibles)
      nil
    end

    def form_address_zip_plus_4(possibles)
      @message.address.zip_full
    end

    def fillout_and_send
      fields = @form.field_names
      subject = fields.delete 'subject'
      form = fields.map do |field|
        [field, self.send(field.to_sym, @form.field_options(field))]
      end.to_h
      form['subject'] = form['topic']
      binding.pry
    end

  end
end

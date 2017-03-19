class @MessageForm extends Form
  constructor: (element)->
    super element
    @address_handler()

  address_handler: ->
    @element.find('.address').on 'field.change', (e, field)=>
      fields = @fields '.address'
      for field in fields
        return false unless field.is_valid()
      field_values = Array.from(fields.map (index, field)->
        [field.name(), field.value()]
      ).to_hash()
      debugger

  dlegislators_from_address: ->

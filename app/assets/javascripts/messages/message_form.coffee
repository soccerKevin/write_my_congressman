class @MessageForm extends Form
  constructor: (element)->
    super element
    @address_handler()

  address_handler: ->
    @element.find('.address').on 'field.change', (e, field)=>
      for field in @fields '.address'
        return false unless field.is_valid()
      uri = new URI('/address/legislators').addQuery @field_values('.address')


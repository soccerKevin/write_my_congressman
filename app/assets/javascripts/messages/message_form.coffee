class @MessageForm extends Form
  constructor: (element)->
    super element
    @address_handler()

  address_handler: ->
    @element.find('.address').on 'field.change', (e, field)=>
      for field in @fields '.address'
        return false unless field.is_valid()
      uri = new URI('/messages/address')
      $.get( uri.fullURI(), @data(@fields('.address')))
        .done( (data, status, response)->
          $('.legislator_container .legislators').empty().append $(data.html)
        ).fail (response, status, message)->
          console.log "fail: ", response


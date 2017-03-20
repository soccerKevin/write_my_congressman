class @MessageForm extends Form
  constructor: (element)->
    super element
    @address_handler()

  address_handler: ->
    @element.find('.address').on 'field.change', (e, field)=>
      for field in @fields '.address'
        return false unless field.is_valid()
      @legislators_from_address()

  legislators_from_address: ->
    uri = new URI('/messages/address')
    $.get( uri.fullURI(), @data(@fields('.address')))
      .done( (data, status, response) =>
        @replace_legislators data.html
      ).fail (response, status, message) =>
        console.log "fail: ", response

  replace_legislators: (html)->
    $legs = $(html).not('.donald_trump').not('.mike_pence')
    $('.legislator_container .legislators').empty().append $legs

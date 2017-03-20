class @Message
  constructor: ->
    @message_form = new MessageForm '.message_form form'

$ ->
  window.message = new Message()

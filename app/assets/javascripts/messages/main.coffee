class @Message
  constructor: ->
    @user_form = new UserForm '.message_form form'

$ ->
  window.message = new Message()

class @Message
  constructor: ->
    @user_form = new Form '.user_info form'

$ ->
  window.message = new Message()

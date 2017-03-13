class @FormField
  constructor: (container, name)->
    @container = $(container)
    @object_name = name
    @handlers()

  input: ->
    @input_cache ||= @container.find('input, select, textarea').first()

  name: ->
    @input().attr 'name'

  value: ->
    @input().val()

  is_empty: ->
    @value().is_empty()

  handlers: ->
    @container.on 'keyup', (e)=>
      @container.trigger 'field.change', @

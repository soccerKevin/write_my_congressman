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

  is_valid: ->
    !@is_empty()

  is_empty: ->
    @value().is_empty()

  has_parent: (elem_selector)->
    @container.parents(elem_selector).length > 0

  handlers: ->
    @container.on 'keyup', (e)=>
      @container.trigger 'field.change', @

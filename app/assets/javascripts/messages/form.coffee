class @Form
  constructor: (element)->
    @element = $(element)
    @fields()
    @base_handlers()

  ajax_save: ->
    $.post(
      url: @url()
      data: @data()
      dataType: 'JSON'
    ).done( ()=>
      console.log "save successful"
    ).fail ()=>
      console.log "failed to save"

  url: ->
    @element.attr 'action'

  fields: ->
    @fields_cache ||= @element.find('.field').map (index, field)=>
      new FormField field

  save: ->
    if @is_remote() then @ajax_save() else @rails_save()

  has_empty_field: ->
    empties = for field in @fields()
      field.is_empty()
    empties.includes true

  is_remote: ->
    @element.attr 'data-remote' == 'true'

  rails_save: ->
    @element.find('input[type=sumbit]').click()

  data: ->
    data = new Data
    @fields().map (index, field)->
      data.add_field_name field.name(), field.value()
    JSON.parse JSON.stringify data.hash

  base_handlers: ->
    @save_handler()

  save_handler: ->
    @element.on 'field.change', (field)=>
      @save() unless @has_empty_field()

  class Data
    constructor: ->
      @hash = {}

    add_field_name: (name, value)->
      elements = name.replace_all(']', '').split('[')
      obj = @hash

      index = 0
      for elem in elements
        if obj.hasOwnProperty elem
          obj = obj[elem]
        else
          if elements[index + 1]
            obj[elem] = {}
            obj = obj[elem]
          else
            obj[elem] = value
        index++


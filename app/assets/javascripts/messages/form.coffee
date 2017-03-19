class @Form
  constructor: (element)->
    @element = $(element)
    @fields()

  ajax_save: ->
    $.post(
      url: @url()
      data: @data()
      dataType: 'JSON'
    ).done( =>
      console.log "save successful"
    ).fail =>
      console.log "failed to save"

  url: ->
    @element.attr 'action'

  fields: (group_selector='')->
    return @fields_all() if group_selector.is_empty()
    @fields_all().filter (index, field)->
      field.has_parent group_selector

  #private
  fields_all: (reset=false)->
    @fields_cache = null if reset
    @fields_cache ||= @element.find('.field').map (index, field)=>
      new FormField field

  save: ->
    if @is_remote() then @ajax_save() else @rails_save()

  has_empty_field: ->
    empties = for field in @fields()
      field.is_empty()
    empties.includes true

  is_remote: ->
    @element.attr('data-remote') == 'true'

  rails_save: ->
    @element.find('input[type=sumbit]').click()

  data: (fields=@fields)->
    data = new Data()
    fields.map (index, field)->
      data.add_field_name field.name(), field.value()
    JSON.parse JSON.stringify data.hash

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


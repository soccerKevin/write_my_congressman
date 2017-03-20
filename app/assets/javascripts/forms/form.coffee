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

  field_values: (group_selector='')->
    @fields(group_selector).map( (index, field)->
      [field.name(), field.value()]
    ).to_hash()

  fields: (group_selector='')->
    return @fields_all().get() if group_selector.is_empty()
    @fields_all().filter( (index, field)->
      field.has_parent group_selector
    ).get()

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

  data: (fields=@fields())->
    fields.map( (field)->
      [field.name(), field.value()]
    ).to_hash()

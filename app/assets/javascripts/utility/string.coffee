String::is_empty = ->
  @length < 1

String::replace_all = (search, replacement)->
  target = @
  target.replace new RegExp(search, 'g'), replacement

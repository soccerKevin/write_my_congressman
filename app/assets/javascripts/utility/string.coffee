String::is_empty = ->
  @length < 1

String::blank = ->
  @is_empty()

String::replace_all = (search, replacement)->
  target = @
  target.replace new RegExp(search, 'g'), replacement

String::contains = (substr)->
  @indexOf(substr) > -1

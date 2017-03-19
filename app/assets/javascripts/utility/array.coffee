Array::uniq = ->
  uniq = []
  @forEach (element)=>
    uniq.push element unless uniq.includes element
  uniq

Array::includes = (element)->
  @indexOf(element) > -1

Array::first = (count = 1)->
  # if count < 1 then @ else @[0..count]
  return @ if count < 1
  selection = @slice(0, count)
  if selection.length < 2 then selection[0] else selection

Array::last = (count = 1)->
  # if count < 1 then @ else @[-count..-1]
  return @ if count < 1
  selection = @slice(@length - count, @length)
  if selection.length < 2 then selection[0] else selection

Array::compact = ->
  @filter (elem)-> exists elem

Array::group = (func)->
  groups = {}
  for element in @
    bucket = func element
    groups[bucket] = [] unless !!groups[bucket]
    groups[bucket].push element

  groups

Array::is_empty = ->
  @length < 1

Array::blank = ->
  @is_empty()

Array::not_empty = ->
  !@is_empty()

Array::present = ->
  @length > 0

Array::to_hash = ->
  h = {}
  for value, index in @ by 2
    h[@[index]] = @[index + 1]
  h

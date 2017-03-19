class @URI
  constructor: (uri)->
    [@path, temp] = uri.split '?'
    [query, hash] = if temp then temp.split '#' else ['', '']
    @hash = @parseHash hash
    @query = @parseQuery query

  addQuery: (query)->
    for key of query
      if query.hasOwnProperty key
        @query[key] = query[key]

  parseQuery: (query) ->
    return {} if query.blank()
    pairs = query.split '&'
    q = {}
    for kv in pairs
      pair = kv.split '='
      q[pair[0]] = pair[1]
    q

  parseHash: (hash)->
    hash ||= ''
    if hash.contains '#' then hash.substr(1) else hash

  buildHash: ->
    if @hash.blank() then @hash else "##{@hash}"

  removeQuery: ->
    @query = ''

  replaceHistory: ->
    uri = "#{@path}#{@buildQuery()}#{@buildHash()}"
    history.pushState null, null, uri

  buildQuery: ->
    return '' if Object.keys(@query).length < 1
    q = ''
    for key of @query
      if @query.hasOwnProperty key
        special = if q.blank() then '?' else '&'
        q += "#{special}#{key}=#{@query[key]}"
    q

  @currentURI: ->
    new URI location.href

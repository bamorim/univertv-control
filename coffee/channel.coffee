class @Channel
  constructor: (id) ->
    @id = id
    $.getJSON "/channel/#{id}", (data) ->
      @videos = data
      @callback(@videos)

  complete: (callback) -> @callback = callback
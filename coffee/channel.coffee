class @Channel
  constructor: (id) ->
    @id = id
    $.getJSON "/channel/#{id}", (data) =>
      @videos = data
      @callback(@videos) if @callback

  complete: (callback) -> 
    @callback = callback
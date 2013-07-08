class @Video
  constructor: (id) ->
    @id = id

  url: (hd = false) ->
    "http://146.164.98.130/videos/mp4/#{@id}#{("_hd" if hd) || ""}.mp4"
class @Player
  constructor: (id) ->
    @hd = true
    @container = document.getElementById(id)
    video_tag = document.createElement "video"
    video_tag.setAttribute "id", id+"_video"
    video_tag.setAttribute "data-setup", '{"techOrder": ["html5", "flash"]}'
    @container.appendChild video_tag
    @v = _V_(id+"_video")

  load: (id) ->
    delete @video
    @video = new Video(id)
    @reload()

  play: -> @v.play()
  pause: -> @v.pause()
  toggle_hd: ->
    @hd = !@hd
    @reload(@v.currentTime())

  volume: (vol) -> @v.volume(vol)


  reload: (current_time = 0) ->
    @v.wasPlaying = !@v.paused()
    @v.src(@video.url(@hd))
    @v.addEvent "loadedmetadata", ->
      @currentTime(current_time)
      @play() if @wasPlaying
      @removeEvent "loadedmetadata"
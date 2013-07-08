$ ->
  socket = io.connect "http://localhost:3700"
  player = new Player("player")
  player.onChange ->
    socket.emit 'status', player.status
  player.load "smhNWSWGjU4m9avO" # Loads a default video

  socket.on 'control', (data) ->
    switch data.do
      when "play" then player.play()
      when "pause" then player.pause()
      when "load" then player.load(data.arg)
      when "toggle-hd" then player.toggle_hd()
      when "volume-up" then player.volume(player.volume() + 0.1)
      when "volume-down" then player.volume(player.volume() - 0.1)
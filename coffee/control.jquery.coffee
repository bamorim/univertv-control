$ ->
  socket = io.connect "http://localhost:3700"
  $(".control").click ->
    data = {do: $(this).attr("data-control")}
    data.arg = $(this).attr("data-arg") if $(this).attr("data-arg")
    socket.emit 'control', data

  $("#video-select").on 'change', ->
    $("#load-button").attr("data-arg", $(@).val()).attr("disabled",false)

  $("#channel-select").on 'change', ->
    $("#load-button").attr("disabled",true)
    channel = new Channel($(@).val())
    channel.complete (data) ->
      $("#video-select").html ""
      for video in data
        $("#video-select").append("<option value='#{video.id}'>#{video.name}</option>")
      $("#video-select").attr("disabled",false).change()


  $.getJSON "/channels", (data) ->
    $("#load-button").attr("disabled",true)
    $("#channel-select").html ""
    for channel in data
      $("#channel-select").append("<option value='#{channel.id}'>#{channel.name}</option>")
    $("#channel-select").change()
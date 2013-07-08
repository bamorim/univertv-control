express = require "express"
app = express()
server = require("http").createServer app
io = require("socket.io").listen server

app.set "views", __dirname + "/tpl"
app.set "view engine", "jade"
app.engine "jade", require("jade").__express
app.use express.static(__dirname + '/public')

app.get "/", (req,res) ->
  res.render "player"

app.get "/control", (req,res) ->
  res.render "control"

api = (uri, regex, parser, callback) ->
  console.log "Begin api call"
  req = require('http').get uri, (res) ->
    console.log "Status Code: #{res.statusCode}"
    resp = ""
    if res.statusCode == 200
      res.setEncoding 'utf8'
      res.on 'data', (chunk) -> resp += chunk
      res.on 'end', ->
        console.log "Response: #{res.statusCode}"
        index = 0
        matches = []
        while(match = resp.substr(index).match(regex))
          index += match[0].length + match.index
          matches.push parser(match)
        req.end()
        callback(matches)
    else
      callback([])

app.get "/channel/:id", (req,res) ->
  api "http://univertv.lab3d.coppe.ufrj.br/webcast/listarItensFaixaAjax?id=#{req.params.id}",
  /a href="Javascript:mudaVideo\(([0-9]+), '(([^']|\\')*)'[\S]+\s+[\S ]+span>\s+([\S ]+)\s+<\/span>/im,
  ((match) -> {id: match[2], name: match[4]}),
  ((videos) -> res.send(videos))

app.get "/channels", (req,res) ->
  api "http://univertv.lab3d.coppe.ufrj.br/webcast/listarFaixas",
  /a href="exibirFaixa\?id=([0-9]+)">(([^<]|\\<)*)</,
  ((match) -> {id: match[1], name: match[2]}),
  ((channels) -> res.send(channels))


io.sockets.on 'connection', (socket) ->
  #TODO: Retransmit only to user's player
  socket.on 'control', (data) ->
    io.sockets.emit 'control', data

server.listen 3700
console.log "Listening on port 3700"
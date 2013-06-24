Express = require "express"
FS = require "fs"
Path = require "path"

WORK_DIR = process.argv[2] or "."

App = Express()

App.use Express.logger()
App.use Express.favicon()
App.use Express.methodOverride() # http://senchalabs.github.com/connect/middleware-methodOverride.html
App.use Express.cookieParser()   # http://senchalabs.github.com/connect/middleware-cookieParser.html
App.use Express.responseTime()   # http://senchalabs.github.com/connect/middleware-responseTime.html
App.set "view engine", "jade"
App.set "view options", layout: false
App.enable 'trust proxy' # important for getting the correct remote ip from haproxy and forward to rails
App.enable "case sensitive routing"
App.use Express.bodyParser()

# App.use App.router


App.all "/*", (req, res, next) ->
  file = req._parsedUrl.pathname
  if ( file is "/" )
    file = "/index.html"
  console.info file
  res.sendfile Path.normalize("#{WORK_DIR}/#{file}")

HTTP = require('http')
App.SERVER = HTTP.createServer App

App.SERVER.listen process.argv.NODE_PORT or 9000, ->
  console.info "listening on #{process.argv.NODE_PORT or 9000}"
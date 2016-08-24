var express = require('express')
var config = require('./config')
var serveStatic = require('serve-static')
var multipart = require('connect-multiparty')
var multipartMiddleware = multipart()
var path = require('path')
var fs = require('fs')
var qiniu = require("qiniu")

qiniu.conf.ACCESS_KEY = config.qiniu.accessKey
qiniu.conf.SECRET_KEY = config.qiniu.secretKey

function uptoken(key) {
  var putPolicy = new qiniu.rs.PutPolicy('freeze-it' + ':' + key)
  return putPolicy.token()
}

var app = express()
app.set('view engine', 'jade')

app.get('/', function(req, res) {
  res.render('index', {
    title: 'Hey',
    message: 'Hello there!'
  })
})

app.get('/p/:uuid', function(req, res) {
  var uuid = req.params.uuid
  res.render('p', {
    src: config.qiniu.domain + uuid
  })
})

app.use('/static', serveStatic('static/build/', {
  setHeaders: function(res, path) {
    res.setHeader('Cache-control', 'public, max-age=0')
  }
}))

app.post('/api/v1/upload', multipartMiddleware, function(req, res) {
  var body = req.body
  var key = body.uuid
  var imagePath = req.files.gif.path
  var extra = new qiniu.io.PutExtra()
  qiniu.io.putFile(uptoken(key), key, imagePath, extra, function(err, ret) {
    if (!err) {
      console.log(ret.hash, ret.key, ret.persistentId)
      res.send({
        code: 200
      })
    } else {
      res.send({
        code: 500
      })
      console.log(err)
    }
  })
})

app.listen(3001, function() {
  console.log('server listen on 3001')
})
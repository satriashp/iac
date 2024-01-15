const https = require('https')
const fs = require('fs')

const tls = {
  key: fs.readFileSync("/work/certs/tls.key"),
  cert: fs.readFileSync("/work/certs/tls.crt")
}

const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3000

app.use(bodyParser.json())

app.get('/health', (req, res) => {
  res.send('up and running');
})

app.post('/validate', (req, res) => {
  var body = req.body

  res.status(200).json({
    "apiVersion": body.apiVersion,
    "kind": "AdmissionReview",
    "response": {
      "uid": body.request.uid,
      "allowed": false,
      "status": {
        "code": 403,
        "message": "Your action forbidden. PLease Contact Hosting Team. #dac-update-crds-denied."
      }
    }
  }).end()
})

app.listen(port, () => {
  console.log(`Server start listeninng on port ${port}`)
})

process.on('SIGTERM', () => {
  debug('SIGTERM signal received: closing HTTP server')
  server.close(() => {
    debug('HTTP server closed')
  })
})

https.createServer(tls, app).listen(443);

'use strict'

const fs = require('fs')
const path = require('path')
const watch = require('watch')
const MustHave = require('musthave')
const mh = new MustHave({
  throwOnError: false
})
const AWS = require('aws-sdk')

// General error handler
process.on('uncaughtException', function (e) {
  console.error(e.message)
})

// Verify required envionrment variables exist.
if (!mh.hasAll(process.env, 'AWS_KEY', 'AWS_SECRET', 'AWS_BUCKET', 'DOMAIN')) {
  console.error('Missing environment variables:', mh.missing)
  process.exit(1)
}

// Helper methods
const isReadable = function (file) {
  try {
    fs.accessSync(file, fs.R_OK)
    return true
  } catch (e) {
    console.log(e)
    return false
  }
}

// Watch the domains directory for updates
watch.createMonitor('/domains/' + process.env.DOMAIN, function (monitor) {
  monitor.on('created', function (f, stat) {
    console.log('CREATE', f, stat)
  })
  monitor.on('changed', function (f, curr, prev) {
    console.log('MODIFY', f, stat)
  })
  monitor.on('removed', function (f, stat) {
    console.log('REMOVE', f, stat)
  })
  console.log('Awaiting SSL certificate updates for', process.env.DOMAIN)
})

// 1. When fullchain.pem AND private.key are available, concatenate them.
// 2. When concatenation is done, push to S3.

process.stdin.resume()

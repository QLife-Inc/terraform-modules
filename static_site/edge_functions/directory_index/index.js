'use strict'

exports.handler = (event, _context, callback) => {
  const request = event.Records[0].cf.request;
  if (/\/$/.test(request.uri)) {
    request.uri += 'index.html'
  }
  callback(null, request)
}
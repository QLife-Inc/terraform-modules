"use strict";

function hasTrallingSlash(uri) {
  return /\/$/.test(uri);
}

function hasNoExtension(uri) {
  return !/\/[^\/]+\.[^\/.]+$/.test(uri);
}

exports.handler = (event, _context, callback) => {
  const request = event.Records[0].cf.request;
  if (hasTrallingSlash(request.uri)) {
    request.uri += "index.html";
  } else if (hasNoExtension(request.uri)) {
    request.uri += "/index.html";
  }
  callback(null, request);
};

const ALLOWED_IP_ADDRESSES = '${allowed_ip_addresses}'
  .split(',')
  .map(ip => ip.replace(/^\s+|\s+$/g, ''))

function isAllowedClientIp(clientIp) {
  if (ALLOWED_IP_ADDRESSES.length === 0) return true
  return ALLOWED_IP_ADDRESSES.includes(clientIp)
}

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;

  if (isAllowedClientIp(request.clientIp)) {
    callback(null, request)
    return
  }

  callback(null, {
    status: '403',
    statusDescription: 'Forbidden',
    body: `
    <!DOCTYPE html>
    <html>
      <head><title>Forbidden</title></head>
      <body><h1>Forbidden</h1></body>
    </html>
    `,
    headers: {
      'Content-Type': [{
        key: 'content-type',
        value: 'text/html; charset=utf-8'
      }]
    }
  })
}
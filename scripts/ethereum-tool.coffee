https = require 'https'

class EthereumTool
  getPrice: (exchangeplace, callback) ->
    url = ""
    if exchangeplace == "kraken"
      url = 'https://api.kraken.com/0/public/Ticker?pair=ETHXBT'
    else
        return null
    https.get url, (response) ->
      body = '';
      response.on 'data', (chunk) ->
        body += chunk;
      response.on 'end', () ->
        callback(JSON.parse(body).result.XETHXXBT.c[0])
module.exports = EthereumTool

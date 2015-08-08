https = require 'https'

class EthereumTool
  getPrice: (exchangeplace, callback) ->
    url = ""
    if exchangeplace == "kraken"
      url = 'https://api.kraken.com/0/public/Ticker?pair=ETHXBT'
      https.get url, (response) ->
        body = '';
        response.on 'data', (chunk) ->
          body += chunk;
        response.on 'end', () ->
          callback(JSON.parse(body).result.XETHXXBT.c[0])
    else if exchangeplace == "poloniex"
      url = 'https://poloniex.com/public?command=returnTicker'
      https.get url, (response) ->
        body = '';
        response.on 'data', (chunk) ->
          body += chunk;
        response.on 'end', () ->
          callback(JSON.parse(body).BTC_ETH.last)
    else
      return null
module.exports = EthereumTool

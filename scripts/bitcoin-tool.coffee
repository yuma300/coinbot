https = require 'https'
Promise = require('bluebird');

class BitcoinTool
  getPrice: (exchangeplace, callback) ->
    url = ""
    if exchangeplace == "zaif"
      url = 'https://api.zaif.jp/api/1/ticker/btc_jpy'
    else if exchangeplace == "coincheck"
      url = 'https://coincheck.jp/api/ticker'
    else
        return null
    https.get url, (response) ->
      body = '';
      response.on 'data', (chunk) ->
        body += chunk;
      response.on 'end', () ->
        callback(JSON.parse(body).last)
        #res.send '1BTC = ' + JSON.parse(body).last + 'JPY'
        #return JSON.parse(body).last
module.exports = BitcoinTool

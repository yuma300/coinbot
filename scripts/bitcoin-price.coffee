# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
https = require 'https'

module.exports = (robot) ->
   robot.respond /price bitcoin zaif/, (res) ->
     https.get 'https://api.zaif.jp/api/1/ticker/btc_jpy', (response) ->
       body = '';
       response.on 'data', (chunk) ->
         body += chunk;
       response.on 'end', () ->
         res.send '1BTC = ' + JSON.parse(body).last + 'JPY'

   robot.respond /price bitcoin coincheck/, (res) ->
     https.get 'https://coincheck.jp/api/ticker', (response) ->
       body = '';
       response.on 'data', (chunk) ->
         body += chunk;
       response.on 'end', () ->
         res.send '1BTC = ' + JSON.parse(body).last + 'JPY'

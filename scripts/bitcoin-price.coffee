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
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    bt.getPrice 'zaif', (last_price)->
      res.send '1BTC = ' + last_price + 'JPY'

  robot.respond /price bitcoin coincheck/, (res) ->
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    bt.getPrice 'coincheck', (last_price)->
      res.send '1BTC = ' + last_price + 'JPY'

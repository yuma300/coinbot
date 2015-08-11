# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  BitcoinTargetPriceNotifier = require("./bitcoin-target-price-notifier")
  notifier = new BitcoinTargetPriceNotifier(robot)
  robot.brain.data.bitcoin_target_price_notifys = []

  robot.respond(/check notifys$/i, (res) ->
    notifier.checkNotifys (notify) ->
      res.send "@#{notify.envelope.user.name} bitcoin price #{notify.type} than #{notify.price} at #{notify.place}"
  )

  robot.respond(/show notifys$/i, (res) ->
    notifier.showNotifys (notify) ->
      res.send notify.type + ' ' + notify.price + ' ' + notify.place + ' ' + notify.envelope
  )

  robot.respond(/notify-target-price bitcoin (lower|higher) (zaif|coincheck) ([0-9]+$)/i, (res) ->
    type = res.match[1]
    place = res.match[2]
    price = res.match[3]
    options =
      type: type,
      price: price,
      place: place,
      envelope: res.envelope
    robot.brain.data.bitcoin_target_price_notifys.push(options)
    res.send "I'll remind you to #{type} #{price}"
  )

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

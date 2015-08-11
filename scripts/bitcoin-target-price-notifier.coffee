async = require('async');

class BitcoinTargetPriceNotifier
  constructor: (@robot) ->

  showNotifys: (res) ->
    for notify, index in @robot.brain.data.bitcoin_target_price_notifys
      res.send(notify.type + ' ' + notify.price + ' ' + notify.place + ' ' + notify.envelope)

  checkNotifys: (res) ->
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    robot = @robot
    async.series [
      (callback) ->
        bt.getPrice 'zaif', (last_price)->
          callback(null, last_price);
      (callback) ->
        bt.getPrice 'coincheck', (last_price)->
          callback(null, last_price);
    ], (err, results) ->
      if (err) 
        throw err;
      prices = { "zaif":results[0], "coincheck":results[1] }
      for notify, index in robot.brain.data.bitcoin_target_price_notifys
        if (notify.type == "higher" && notify.price < prices[notify.place]) || (notify.type == "lower" && notify.price > prices[notify.place])
          outputNotification(res, notify)
          robot.brain.data.bitcoin_target_price_notifys[index] = null
      robot.brain.data.bitcoin_target_price_notifys = robot.brain.data.bitcoin_target_price_notifys.filter(Boolean);
   
    outputNotification = (res, notify) ->
      res.send "@#{notify.envelope.user.name} bitcoin price #{notify.type} than #{notify.price} at #{notify.place}"
    
module.exports = (robot) ->
  notifier = new BitcoinTargetPriceNotifier(robot)
  robot.brain.data.bitcoin_target_price_notifys = []

  robot.respond(/check notifys$/i, (res) ->
    notifier.checkNotifys(res)
  )

  robot.respond(/show notifys$/i, (res) ->
    notifier.showNotifys(res)
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

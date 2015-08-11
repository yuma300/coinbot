async = require('async');

class BitcoinTargetPriceNotifier
  constructor: (@robot) ->
  showNotifys: (res) ->
    for notify, index in @robot.brain.data.bitcoin_target_price_notifys
      res.send(notify.type + ' ' + notify.price + ' ' + notify.place)
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
      console.log('all done');
      console.log(results);
      zaif_price = results[0]
      coincheck_price = results[1]
      for notify, index in robot.brain.data.bitcoin_target_price_notifys
        if notify.place == "zaif"
          if notify.type == "higher" && notify.price < zaif_price
            res.send 'higher!!'
        else if notify.place == "coincheck"
          res.send '1BTC = JPY'
          #bt.getPrice 'coincheck', (last_price)->
          #  res.send '1BTC = ' + last_price + 'JPY'
    
    #@robot.brain.data.bitcoin_target_price_notifys = []
    
    
      
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
      place: place
    robot.brain.data.bitcoin_target_price_notifys.push(options)
    res.send "I'll remind you to #{type} #{price}"
  )

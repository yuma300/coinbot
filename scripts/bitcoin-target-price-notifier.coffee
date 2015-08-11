async = require('async');

class BitcoinTargetPriceNotifier
  constructor: (@robot) ->

  showNotifys: (callback) ->
    for notify, index in @robot.brain.data.bitcoin_target_price_notifys
      callback(notify)

  checkNotifys: (callback) ->
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    robot = @robot
    async.series [
      (callback) ->
        bt.getPrice 'zaif', (last_price) ->
          callback(null, last_price);
      (callback) ->
        bt.getPrice 'coincheck', (last_price) ->
          callback(null, last_price);
    ], (err, results) ->
      if (err) 
        throw err;
      prices = { "zaif":results[0], "coincheck":results[1] }
      for notify, index in robot.brain.data.bitcoin_target_price_notifys
        if (notify.type == "higher" && notify.price < prices[notify.place]) || (notify.type == "lower" && notify.price > prices[notify.place])
          callback(notify)
          robot.brain.data.bitcoin_target_price_notifys[index] = null
      robot.brain.data.bitcoin_target_price_notifys = robot.brain.data.bitcoin_target_price_notifys.filter(Boolean);
module.exports = BitcoinTargetPriceNotifier

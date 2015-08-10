class BitcoinTargetPriceNotifier
  constructor: (@robot) ->
  showNotifys: (res) ->
    for notify, index in @robot.brain.data.bitcoin_target_price_notifys
      res.send(notify.type + ' ' + notify.price)
  checkNotifys: (res) ->
    for notify, index in @robot.brain.data.bitcoin_target_price_notifys
      res.send(notify.type + ' ' + notify.price)
      
module.exports = (robot) ->
  notifier = new BitcoinTargetPriceNotifier(robot)
  robot.brain.data.bitcoin_target_price_notifys = []

  robot.respond(/check notifys$/i, (res) ->
    notifier.checkNotifys(res)
  )

  robot.respond(/show notifys$/i, (res) ->
    notifier.showNotifys(res)
  )

  robot.respond(/notify-target-price bitcoin (lower|higher) ([0-9]+$)/i, (res) ->
    type = res.match[1]
    price = res.match[2]
    options =
      type: type,
      price: price
    robot.brain.data.bitcoin_target_price_notifys.push(options)
    res.send "I'll remind you to #{type} #{price}"
  )

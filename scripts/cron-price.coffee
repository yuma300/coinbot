cronJob = require('cron').CronJob

module.exports = (robot) ->
  cronTest = new cronJob('00 00 0,4,8,12,16,20 * * *', () =>
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    bt.getPrice 'zaif', (last_price)->
      envelope = room: "#bitcoin"
      robot.send envelope, "1BTC = " + last_price + "JPY @zaif https://zaif.jp/"
    bt.getPrice 'coincheck', (last_price)->
      envelope = room: "#bitcoin"
      robot.send envelope, "1BTC = " + last_price + "JPY @coincheck https://coincheck.jp/"
  )
  cronTest.start()


cronJob = require('cron').CronJob

module.exports = (robot) ->
  cronBitcoin = new cronJob('00 00 0,4,8,12,16,20 * * *', () =>
    BitcoinTool = require("./bitcoin-tool")
    bt = new BitcoinTool()
    bt.getPrice 'zaif', (last_price)->
      envelope = room: "#bitcoin"
      robot.send envelope, "1BTC = " + last_price + "JPY @zaif https://zaif.jp/"
    bt.getPrice 'coincheck', (last_price)->
      envelope = room: "#bitcoin"
      robot.send envelope, "1BTC = " + last_price + "JPY @coincheck https://coincheck.jp/"
  )
  cronBitcoin.start()
  cronEthereum = new cronJob('00 00 0,4,8,12,16,20 * * *', () =>
    EthereumTool = require("./ethereum-tool")
    et = new EthereumTool()
    et.getPrice 'kraken', (last_price)->
      envelope = room: "#ethereum"
      robot.send envelope, "1ETH = " + last_price + "BTC @kraken https://www.kraken.com/"
  )
  cronEthereum.start()


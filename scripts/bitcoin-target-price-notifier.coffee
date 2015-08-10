module.exports = (robot) ->
  robot.respond(/show reminders$/i, (msg) ->
    for notify, index in robot.brain.data.notifys
      msg.send(notify.action)
  )

  robot.respond(/remind me (lower|higher) (.+?) to (.*)/i, (msg) ->
    type = msg.match[1]
    price = msg.match[2]
    action = msg.match[3]
    options =
      type: type,
      price: price,
      action: action
    robot.brain.data.notifys.push(options)
    msg.send "I'll remind you to #{price}"
  )

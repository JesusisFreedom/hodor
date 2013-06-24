# TimeRounder
# Rounds off time to the nearest 15 minute.
window.TimeRounder = TimeRounder ? new Object

$ ->
  TimeRounder.isFactorOf15 = (minutes) ->
    (minutes * 60) % 900  == 0

  TimeRounder.roundOff = (minutes) ->
    if !TimeRounder.isFactorOf15(minutes)
      return (Math.floor(minutes/15) * 15)+ 15
    minutes

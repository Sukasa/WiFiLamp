Config = require("Config")

MQTT = mqtt.Client(Config.ClientName)

MQTT:on("message",
  function(conn, topic, data)
    if data == "1" then
      On()
    elseif data == "0" then
      Off()
    end
  end
)

MQTT:on("connect", function(con) MQTT:subscribe(Config.Topic, 0) end)

function WaitWifi()
  if (wifi.sta.status() == 5) then
    tmr.stop(0)
    MQTT:connect(Config.Server)
  end
end

function On()
  gpio.write(7, gpio.LOW)
end

function Off()
  gpio.mode(7, gpio.INPUT, gpio.FLOAT)
end

Off()
On()
wifi.setmode(wifi.STATION)
wifi.sta.config(Config.SSID, Config.PW)
wifi.sta.connect()
tmr.alarm(0, 1000, tmr.ALARM_AUTO, WaitWifi)
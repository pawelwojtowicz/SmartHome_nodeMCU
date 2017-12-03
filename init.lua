commLink = require "communicationLink"
deviceMngr = require "device"
rfid = require "RFC522"

deviceMngr.initializeDevice(commLink)


function printTagId (tagId)
	strT = "Received tag id: "
	strT = strT..tagId
	print(strT)
	local rfidTagMsg = {}
	rfidTagMsg["tagId"] = tagId
	rfidTagMsg["timestamp"] = tmr.time()
	
	commLink.sendMQTTMessage( "rfidTag" , rfidTagMsg, 2 )
end	
--rfid.rfidInit(printTagId)



function periodicalReporting()
	print("PeriodicalReporting")
	deviceMngr.reportDeviceStatus()
end


tmr.alarm(1, 5000, tmr.ALARM_AUTO, periodicalReporting )

rfid.rfidInit(printTagId)

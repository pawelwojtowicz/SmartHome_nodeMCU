rfid = require "RFC522"

function printTagId (tagId)
	strT = "Received tag id: "
	strT = strT..tagId
	print(strT)
end

rfid.rfidInit(printTagId)

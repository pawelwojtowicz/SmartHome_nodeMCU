local wlanSSID = "InternetDlaNinija"
local password = "lubiebiegacwtoplesie"
local macAddress = wifi.sta.getmac()
local incommingTrafficTopicPrefix = ""
local outgoingTrafficTopicPrefix = ""
local lastWillTestamentPayload = "{ \"status\": \"offline\", \"uptime\": 0 }"
local callbacks = {}

mqttBrokerIP = "192.168.1.102"
m=mqtt.Client()
connectedClient = nil


local function getIP( )
	return wifi.sta.getip()
end


local function connectionOk( client )
	connectedClient = client
	print("mqtt broker successfully connected")
	macAddress = wifi.sta.getmac() 
	incommingTrafficTopicPrefix = "wifi/" .. macAddress  .. "/in/"
	outgoingTrafficTopicPrefix = "wifi/" .. macAddress  .. "/out/"
	connectedClient:subscribe( incommingTrafficTopicPrefix .."#" , 1)
	connectedClient:lwt(outgoingTrafficTopicPrefix .. "status", lastWillTestamentPayload, 2, 1)
end

local function connectionFailed( client, errorReason)
    print("mqttBroker connection failed")
end

local function messageReceived ( client, topic, message) 
	modus = string.gsub(topic, incommingTrafficTopicPrefix, "")

    print ("received topid:[" .. topic .. "] - payload:[" .. messsage .. "]")
	
	callbackFunction = callbacks[modus]
	if (callbackFunction ~= nil) then
		callbackFunction( modus, message )
	end
end

local function connectMQTT()
	m:connect(mqttBrokerIP ,1883,0,1 , connectionOk , connectionFailed)
end

local function clientDisconnected(client)
	connectedClient = nil
	connectMQTT()
end

m:on("connect", connectionOk )
m:on("message", messageReceived)
m:on("offline", clientDisconnected)


local function initCommLink()
	wifi.setmode(wifi.STATION)
	wifi.sta.config { ssid=wlanSSID,pwd="lubiebiegacwtoplesie" }

	connectMQTT()
end

local function sendMQTTMessage( modus , msgPayloadObject, retain)
	if ( connectedClient ~= nil ) then
		topic = outgoingTrafficTopicPrefix .. modus
		
		messageText = sjson.encode(msgPayloadObject)
        print(messageText)
		-- publish a message with data = hello, QoS = 0, retain = 0
		connectedClient:publish(topic, messageText, 1, retain, function(client) print("sent") end)
	else
		connectMQTT()
	end
end

local function subscribeModus( modus, callbackFunction)
	callbacks[modus] = callbackFunction
end

return { initialize = initCommLink , 
		 sendMQTTMessage = sendMQTTMessage ,
		 subscribeModus = subscribeModus
		 }

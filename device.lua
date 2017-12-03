local configFileName = "deviceConfig.txt"
local deviceInfo = {}
local status = {}
local statusModus = "status"

deviceInfo["deviceName"]  = "esp8622-" .. node.chipid()
deviceInfo["deviceIp"] = "0.0.0.0"
deviceInfo["location"] = "home"
deviceInfo["services"] = { "device" }
deviceInfo["statusReportPeriod"] = 30

status["status"] = "online"
status["uptime"] = tmr.time()


local commLink = nil

local function saveConfig()
	cfgFile = file.open(configFileName , "w+")
	cfgFile:writeline(deviceInfo["deviceName"])
	cfgFile:writeline(deviceInfo["location"])
	cfgFile:writeline(deviceInfo["statusReportPeriod"])
	cfgFile:close()
end

local function loadConfig()
	cfgFile = file.open(configFileName , "r")
	deviceInfo["deviceName"] = cfgFile:readline()
	deviceInfo["location"] = cfgFile:readline()
	deviceInfo["statusReportPeriod"] = cfgFile:readline()
	cfgFile:close()
end

local function initializeDevice( communicationLink )
	if not file.exists(configFileName) then
		saveConfig()
	else
		loadConfig()
	end
	
	commLink = communicationLink
end

local function restartDevice()
	node.restart()
end

local function changeDeviceName( newName )
	deviceInfo["deviceName"] = newName
	saveConfig()
end

local function changeLocation( newLocation )
	deviceInfo["location"] = newLocation
	saveConfig()
end

local function changeStatusReportingPeriod( newPeriod)
	deviceInfo["statusReportPeriod"] = newPeriod
	saveConfig()
end

local function reportDeviceStatus()
	status["uptime"] = tmr.time()
	
	if (commLink ~= nil) then
		commLink.sendMQTTMessage( statusModus , status, 2 )
	end
	
end

return { initializeDevice = initializeDevice, 
		 reportDeviceStatus = reportDeviceStatus ,
		 restartDevice = restartDevice,
		 changeDeviceName = changeDeviceName,
		 changeLocation = changeLocation,
		 changeStatusReportingPeriod = changeStatusReportingPeriod }

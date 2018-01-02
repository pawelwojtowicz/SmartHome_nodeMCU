--- the module that publishes the information from the sensor of AM2320 to the
--- central system. It publishes the meta information about capability of the node
--- equipped with the sensor as well as the API, that controls it.

--- Connecting to the module:
--- pinouts:
--- +-------------+
--- | o o o o o o |
--- |  o o o o o  |
--- | o o o o o o |
--- |  o o o o o  |
--- | o o o o o o |
--- +-+--+--+--+--+
---   |  |  |  |
---   |  |  |  |
---   1  2  3  4
--- 1 - Vdd ( 3.1 - 5.5V )
--- 2 - SDA
--- 3 - GND
--- 4 - SCL

---  NodeMCU ------------------------ AM2320 mapping
---          ----------------------------- SDA
---          ----------------------------- SCK
---   3.3V   ----------------------------- Vdd
---    GND   ----------------------------- GND
local sda = 1
local scl = 2


i2c.setup(0, sda, scl, i2c.SLOW) -- call i2c.setup() only once
am2320.setup()
rh, t = am2320.read()
print(string.format("RH: %s%%", rh / 10))
print(string.format("Temperature: %s degrees C", t / 10))
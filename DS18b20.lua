--- the module that publishes the information from the temperature sensor 18B20 to the
--- central system. It publishes the meta information about capability of the node
--- equipped with the sensor as well as the API, that controls it.

--- Connecting to the module:
--- pinouts:
---		   +---+
---		   |   |
---		   |   |
---		   |   |
---		   +---+
--- 		    |||
---		    /|\
---		   / | \
---		  /  |  \
---		 /   |   \
---             /    |    \
---            /     |     \
---           /      |      \
---	      |      |      |
---          red   yellow  black
---          VCC   DATA    GND
---
---  NodeMCU ------------------------ DS18B20 mapping
---     5V   ---------+------------------- VCC
---	              |
---	           R=4.7k
---		      |
---     ??   ---------+------------------- Data (1Wire)
---    GND   ----------------------------- GND
--- using the nodemcu: https://nodemcu.readthedocs.io/en/master/en/modules/ds18b20/


-- 
local ow_pin = 3
ds18b20.setup(ow_pin)

-- read all sensors and print all measurement results
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
    end,{});

-- read only sensors with family type 0x28 and print all measurement results
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
    end,{},0x28);

-- save device roms in a variable
local addr = {}
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        addr[ind] = {string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)"))}
    end,{});

-- read only sensors listed in the variable addr
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
    end,addr);

-- print only parasitic sensors
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        if (par == 1) then
            print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
        end
    end,{});

-- print if temperature is greater or less than a defined value
ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        if (t > 25) then
            print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
        end
        if (t < 20) then
            print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
        end
    end,{});



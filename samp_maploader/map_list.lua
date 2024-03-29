--[[
	map_list.lua

	List of maps to load on startup
	Required settings for each map:
	
	 - id: unique ID
	 - autoload: load map on startup or not
	 - name: custom name
	 - path: map file path
	 - int: interior world of the objects
	 - dim: dimensiom world of the objects
	 - pos: x,y,z teleport position

	If you get any of these settings wrong, the server will tell you upon starting the resource
]]


mapList = {
    {
    	id = 1,
		autoload = true,

    	name = "Office", path = "maps/office.pwn",
    	int = 1, dim = 1, pos = { 1928.7041015625, -343.6083984375, 50.75 },
	},
    {
    	id = 2,
		autoload = false,

    	name = "Mansion", path = "maps/mansion.pwn",
    	int = 1, dim = 2, pos = { 1395.462891,-17.192383,1001 },
	},
    {
    	id = 3,
		autoload = true,
		
    	name = "Gun Shop", path = "maps/gunshop.pwn",
    	int = 1, dim = 3, pos = { -729.7607421875, 1449.6337890625, -89.869453430176 },
	},
    {
    	id = 4,
		autoload = true,
		
    	name = "Prison 1/2", path = "maps/prison1.pwn",
    	int = 1, dim = 4, pos = { 2686.654296875, 1112.6162109375, 1308.5 },
	},
    {
    	id = 5,
		autoload = true,
		
    	name = "Prison 2/2", path = "maps/prison2.pwn",
    	int = 1, dim = 4, pos = { 963.8623046875, 926.2041015625, 1001.1 },
	},
	{
		id = 6,
		autoload = true,
		
    	name = "El Corona", path = "maps/ext_ElCoronaTest.pwn",
    	int = 0, dim = 0, pos = { 1955.64453125, -2051.765625, 13.2 },
	},
}
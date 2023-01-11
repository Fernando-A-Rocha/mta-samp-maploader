--[[
	Author: Fernando

	_config.lua

	All global config variables are in this file:
]]

----------- GENERAL SCRIPT CONFIGURATION -----------

-- saves custom element model ID in its element data under the following names
dataNames = {
	ped = "skinID", player = "skinID", -- must be the same
	vehicle = "vehicleID",
	object = "objectID",
}

-- saves the element's custom model's base model ID
-- useful for getting a vehicle's base model to fetch its original handling, etc
baseDataName = "baseID"

KICK_ON_DOWNLOAD_FAILS = true -- kick player if failed to download a file more than X times
DOWNLOAD_MAX_TRIES = 3 -- Kicked if failed to download a file 3 times, won't happen if above setting is false


----------- DEBUGGING CONFIGURATION -----------

START_STOP_MESSAGES = false -- enable resouce start/stop automatic chat messages
SEE_ALLOCATED_TABLE = false -- automatically executes /allocatedids on startup
ENABLE_DEBUG_MESSAGES = false -- toggle all debug console messages
CHAT_DEBUG_MESSAGES = false -- make debug console messages to go chatbox (better readability imo)


----------- OPTIONAL CONFIGURATION -----------

-- NandoCrypt | https://github.com/Fernando-A-Rocha/mta-nandocrypt
-- The decrypt function needs to be named ncDecrypt inside a decrypter script (named nando_decrypter by default)

ENABLE_NANDOCRYPT = false
NANDOCRYPT_EXT = ".nandocrypt"

SHOW_DOWNLOADING = true
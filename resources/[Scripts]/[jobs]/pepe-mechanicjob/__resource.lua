resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'vehiclemod'

client_scripts {
    "locale.lua",
	"locales/*.lua",
	'config.lua',
	'client/main.lua',
	'client/gui.lua',
	'client/drivingdistance.lua',
}

server_scripts {
    "locale.lua",
	"locales/*.lua",
    'server/main.lua',
	'config.lua',
}

exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus',
}

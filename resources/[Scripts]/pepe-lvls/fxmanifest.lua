fx_version 'cerulean'
games {'gta5'}

client_script 'server/main.lua'

exports {
	'GetLevel',
}


server_exports {
	'GiveLevelExperience',
}
client_script '@/vrpcore.lua'
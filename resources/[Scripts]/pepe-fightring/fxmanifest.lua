fx_version 'adamant'

game 'gta5'
server_script {
    "locale.lua",
	"locales/*.lua",
    'server/server.lua',
    'config.lua'
}

client_script {
    "locale.lua",
	"locales/*.lua",
    'client/client.lua',
    'config.lua'
}
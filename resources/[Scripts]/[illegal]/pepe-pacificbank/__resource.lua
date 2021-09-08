resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    "locale.lua",
    "locales/*.lua",
    '@mka-lasers/client/client.lua',
    'client/main.lua',
    'client/usables.lua',
    'client/func.lua',
    'client/doors.lua',
    'config.lua',
}

server_scripts {
    "locale.lua",
    "locales/*.lua",
    'server/main.lua',
    'config.lua',
}
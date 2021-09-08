resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script {
 "config.lua",
 "client/mugshot.lua",
 "client/client.lua",
 "client/yoga_ez.lua",
 "client/jobs.lua",
}

server_script {
 "config.lua",
 "server/server.lua",
}

exports {
 'GetInJailStatus',
}
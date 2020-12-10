fx_version 'adamant'

game 'gta5'

this_is_a_map 'yes'

server_scripts {
 'config.lua',
 '@mysql-async/lib/MySQL.lua',
 'server/main.lua'
}

client_scripts {
 'config.lua',
 'client/main.lua'
}
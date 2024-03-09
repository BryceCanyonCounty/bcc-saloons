fx_version "adamant"

games { "rdr3" }
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'



client_scripts {
	'client/client.lua',
	'client/menu.lua'

}
shared_script {
	'shared/config.lua',
	'shared/locale.lua',
	'shared/en.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/versioncheck.lua',
	'server/server.lua'
}

files { 'items/*' }

version '1.0.0'
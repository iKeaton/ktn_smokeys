fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Keaton'
version '0.0.1'
description 'Smokeys Weed Shop'

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

shared_scripts {
  'shared/config.lua',
  'shared/effects.lua',
  '@ox_lib/init.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/script.js',
  'assets/*.png',
}

escrow_ignore {
  'shared/*.lua',
  'client/weedrolling.lua',
  'server/weedrolling.lua',
  'html/index.html',
  'html/style.css',
  'html/*.js',
  'assets/*.png',
}
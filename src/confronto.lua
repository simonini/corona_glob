require('src.utils.button_to_go')
require('src.utils.button_to_go_back')

local storyboard = require( "storyboard" )
local confronto = storyboard.newScene()
storyboard.purgeAll()
  local path_audio = 'media/audio/vocali/'
local torna_indietro
function play_sound( event )
  audio.play( event.target.audio )
end

function goto_menuiniziale(e)
  storyboard.removeScene("src.menu_iniziale")
  storyboard.gotoScene("src.menu_iniziale")
end

function go_to_confronto_lunga(event)
  _G.tipo = 'lunga'
  storyboard.removeScene("src.scegli_combinazione")
  storyboard.gotoScene("src.scegli_combinazione") 
end

function go_to_confronto_corto(event)
  _G.tipo = 'corta'
  storyboard.removeScene("src.scegli_combinazione")
  storyboard.gotoScene("src.scegli_combinazione")
end
local lettera_lunga
local lettera_corta 
local size_pulsantoni = 500
local group
function create_lettera_lunga()
    lettera_lunga = display.newImage( group, "media/menu_iniziale/long-".. _G.vocale ..".png")
    lettera_lunga.width = size_pulsantoni
    lettera_lunga.height = size_pulsantoni
    lettera_lunga.x = display.contentWidth / 2 - 250
    lettera_lunga.y = display.contentHeight / 2 
    lettera_lunga.audio = audio.loadSound( path_audio .. _G.vocale:upper() ..'_L.mp3' )
    lettera_lunga:addEventListener("tap", play_sound)
    create_button_to_go(lettera_lunga,_G.vocale)
    lettera_lunga.cerchio_container:addEventListener("tap", go_to_confronto_lunga)
end
function create_lettera_corta()
  -- CORTA
  lettera_corta= display.newImage( group, "media/menu_iniziale/short-a.png")
  lettera_corta.width = size_pulsantoni
  lettera_corta.height = size_pulsantoni
  lettera_corta.x = display.contentWidth / 2 + 250 
  lettera_corta.y = display.contentHeight / 2
  lettera_corta.audio = audio.loadSound( path_audio.. _G.vocale:upper() .. '_S.mp3' )
  lettera_corta:addEventListener("tap", play_sound)
  create_button_to_go(lettera_corta,_G.vocale)
  lettera_corta.cerchio_container:addEventListener("tap", go_to_confronto_corto)
  torna_indietro:addEventListener("tap", goto_menuiniziale)
end

function confronto:createScene( event )
  print("confronto:createScene")
  print("VOCALE ATTUALE:")
  print(_G.vocale)
  -- variabili generiche
  group = self.view
  -- torna indietro
  torna_indietro = button_to_go_back()
  -- mostra le lettere selezioante
  create_lettera_lunga()
  create_lettera_corta()
  group:insert(torna_indietro)
end

confronto:addEventListener( "destroyScene", confronto )
confronto:addEventListener( "enterScene",  confronto )
confronto:addEventListener( "createScene", confronto )

return confronto

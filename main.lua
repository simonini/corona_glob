require ('src.scegli_combinazione')
require ('src.confronto')
local storyboard = require "storyboard"
display.setStatusBar( display.HiddenStatusBar )

_G.vocale = "a"
_G.tipo = "lunga"
_G.combinazione = "a_e"

-- Create a storyboard scene for this module
local scene = storyboard.newScene()
storyboard.isDebug = true
storyboard.gotoScene( "src.scegli_combinazione" )

local gurgle = audio.loadSound('media/audio/GURGLE.wav')
--audio.play( gurgle )

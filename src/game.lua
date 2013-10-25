local Storyboard = require("storyboard")
local game = Storyboard.newScene()
local movieclip = require('src.utils.movieclip')
local Stat = require('src.utils.Stat')
local Pulsantone = require('src.game.Pulsantone')
local pulsantone = {}
local vocali = {"a","e","i","o","u"}
local x_pos = {0, 100, 200, 300, 400}
local all_globuli = {}
local path = 'media/menu_iniziale/'

local globulo_scelto
local score = 0
local back_btn = button_to_go_back()
back_btn.y = 50
back_btn.width = 60
back_btn.height = 60

-- short long
local short = display.newText("short", 830,140,"Hiragino Maru Gothic Pro",30)
local long = display.newText("long", 830,580,"Hiragino Maru Gothic Pro",30)

-- punteggio massimo / record
local size_table_score        = 20
local font_table_score        = "Hiragino Maru Gothic Pro"
local record_punteggio_group  = display.newGroup()
record_punteggio_group.x      = 30 
record_punteggio_group.y      = 20
local punteggio_massimo       = 0
local punteggio_label         = display.newText(record_punteggio_group, "score",  0,   0,  font_table_score, size_table_score)
local punteggio               = display.newText(record_punteggio_group, "0",      90,  20, font_table_score, size_table_score)
local record_label            = display.newText(record_punteggio_group, "record", 150, 0,  font_table_score, size_table_score)
local record_from_data        = Stat.read()
local record                  = display.newText(record_punteggio_group, record_from_data,      220, 0,  font_table_score, size_table_score)

-- audio - right - wrong
local audio_right= audio.loadSound("media/audio/right.mp3")
local audio_wrong = audio.loadSound("media/audio/wrong.mp3")

-- tentativi
local tentativo_debug = display.newText("3", 200, 350, "Hiragino Maru Gothic Pro", 40)
tentativo_debug.alpha = 0
local tentativi_rimasti = 3

-- blocco
local blocca_interazione = false

-- Loading sound
function choose_random_globulo_and_play_audio()
  blocca_interazione = false
  tentativi_rimasti = 3
  tentativo_debug.text = tentativi_rimasti
  globulo_scelto = all_globuli[math.random(#all_globuli)]
  print("NEW RANDOM LETTER !! -->"..globulo_scelto.vocale)
  play_audio_globulo_attuale()

end

function play_anim(target)
  if target ~= nil then
    local myclosure = function() 
      target:nextFrame()
    end
    timer.performWithDelay(5,myclosure,24)
  end
end

function play_anim_globulo_attuale(event)
  print("PLAY GLOBULO ATTUALE")
  play_anim(event.target)
end

function fx_true_or_right_handler(event)
  tentativi_rimasti = tentativi_rimasti -1
  if tentativi_rimasti == 0 then
    tentativo_debug.text = tentativi_rimasti
    choose_random_globulo_and_play_audio()
  else
    tentativo_debug.text = tentativi_rimasti
    play_audio_globulo_attuale()
  end
  blocca_interazione = false
end

function answer_clicked(event)
  
  if blocca_interazione == false then
    blocca_interazione = true
    print("- obbiettivo:")
    print(globulo_scelto.vocale)
    print("- scelto:")
    print(event.target.vocale)
    print(" ")

    if (globulo_scelto == event.target) then
      print "Giusto!"
      score = score+1
      if (score > punteggio_massimo) then
        punteggio_massimo = score
        record.text = punteggio_massimo
        record_saved = Stat.read()
        if (Stat.read() < punteggio_massimo) then
          Stat.write(punteggio_massimo)
        end
      end
      audio.play(audio_right, {onComplete=choose_random_globulo_and_play_audio })
      
      punteggio.text = score
    else
      print "Sbagliato!"
      if score > 0 then
        score = score-1
      end
      audio.play(audio_wrong, {onComplete=fx_true_or_right_handler })
      punteggio.text = score
    end
  end

end

function crea_fila(long_or_short)
  local group = display.newGroup()
  for i=1,5 do
    single_path = path .. long_or_short ..vocali[i] .. "-150/1.png"
    local globo = display.newImage(single_path)
    globo.x = x_pos[i]*1.5 + globo.width
    globo.vocale = long_or_short..vocali[i]
    -- label
    local label = display.newText(vocali[i], 100,480,"Hiragino Maru Gothic Pro",30)
    label.x = globo.x
    -- sound
    local path_audio = 'media/audio/vocali/'
    if (long_or_short=="long-") then
      local audio = audio.loadSound( path_audio .. string.upper(vocali[i]) .. '_L.mp3')
      globo.audio = audio
      label.y = globo.y+100
    else
      local audio = audio.loadSound( path_audio .. string.upper(vocali[i]) .. '_S.mp3')
      globo.audio = audio
      label.y = globo.y-100
    end
    -- tap
    globo:addEventListener("tap", answer_clicked)
    -- insert
    table.insert(all_globuli,globo)
    group:insert(globo)
    group:insert(label)
  end
  return group
end

function crea_pulsantone()
  local pulsantone = Pulsantone.new()
  --pulsantone:addEventListener("tap", play_audio_globulo_attuale)
  --pulsantone:addEventListener("tap", play_anim_globulo_attuale)
  choose_random_globulo_and_play_audio()
  return pulsantone
end

local function go_bk(event) 
  Storyboard.gotoScene( "src.colonna" )
end




function game:createScene(event)
  fila_short = crea_fila("short-")
  fila_long = crea_fila("long-")
  pulsantone = crea_pulsantone()
  self.view:insert(back_btn)
  self.view:insert(fila_short)
  self.view:insert(fila_long)
  self.view:insert(punteggio)
  self.view:insert(short)
  self.view:insert(long)
  self.view:insert(pulsantone)
  self.view:insert(record_punteggio_group)
  fila_short.y = 140
  fila_long.y = 570
  back_btn:addEventListener("tap", go_bk)
end

function play_audio_globulo_attuale()
  audio.play(globulo_scelto.audio)
  pulsantone:play()
end

game:addEventListener( "createScene", game_created )

return game
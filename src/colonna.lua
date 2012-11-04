local Anim        = require('src.colonna.Anim')
local Arrow       = require('src.colonna.Arrow')
local Storyboard  = require("storyboard")
-- display objects
local colonna     = Storyboard.newScene()
local background  = display.newImage("media/sfondi/".._G.vocale..".png")
local back_btn    = button_to_go_back()
local arrow_up    = Arrow.newSprite()
local arrow_dn    = Arrow.newSprite()
local anim        = Anim.newSprite()

local function go_bk(event) Storyboard.gotoScene( "src.scegli_combinazione" ) end
local function go_up(event)
  anim.prev()
  if (anim.counter == 1) then
    arrow_up.alpha = 0
  end
  arrow_dn.alpha = 1
end
local function go_dn(event) 
  anim.next()
  if (anim.counter >= anim.limit) then
    arrow_dn.alpha = 0
  end
  arrow_up.alpha = 1
end

function colonna:createScene( event )
  self.view:insert(background)
  back_btn:addEventListener("tap", go_bk)
  arrow_up:addEventListener("tap", go_up)
  arrow_dn:addEventListener("tap", go_dn)
  arrow_dn.y = display.contentHeight - arrow_dn.height
end
colonna:addEventListener( "createScene" , scene )

return colonna
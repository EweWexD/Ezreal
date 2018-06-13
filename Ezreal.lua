--  [[ Champion ]]
if GetObjectName( GetMyHero()) ~= "Ezreal" then return end

-- [[ Update ]]
local ver = "0.1"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/Ezreal/master/Ezreal.lua", SCRIPT_PATH .. "Ezreal.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/EweWexD/Ezreal/master/Ezreal.version", AutoUpdate)

-- [[ Lib ]]
require ("OpenPredict")
require ("DamageLib")
function EzrealScriptPrint(msg)
	print("<font color=\"#00ffff\">Ezreal Script:</font><font color=\"#ffffff\"> "..msg.."</font>")
end
EzrealScriptPrint("Made by EwEwe")
	


-- [[ Menu ]]
local EzrealMenu = Menu("Ezreal", "Ezreal God Challenger")
-- [[ Combo ]]
EzrealMenu:SubMenu("Combo", "[Ezreal] Combo Settings")
EzrealMenu.Combo:Boolean("Q", "Use Q", true)
EzrealMenu.Combo:Boolean("W", "Use W", true)
EzrealMenu.Combo:Boolean("E", "Use E", false)
-- [[ Harass ]]
EzrealMenu:SubMenu("Harass", "[Ezreal] Harass Settings")
EzrealMenu.Harass:Boolean("Q", "Use Q", true)
EzrealMenu.Harass:Boolean("W", "Use W", true)
EzrealMenu.Harass:Slider("Mana", "Min. Mana", 50, 0, 100, 1)
-- [[ LaneClear ]]
EzrealMenu:SubMenu("Farm", "[Ezreal] Farm Settings")
EzrealMenu.Farm:Boolean("Q", "Use Q", true)
EzrealMenu.Farm:Boolean("QL", "Use Q On LastHit", true)
EzrealMenu.Farm:Slider("Mana", "Min. Mana", 40, 0, 100, 1)
-- [[ Jungle Clear ]]
EzrealMenu:SubMenu("JG", "[Ezreal] Jungle Settings")
EzrealMenu.JG:Boolean("Q", "Use Q", true)
-- [[ Kill Steal ]]
EzrealMenu:SubMenu("KS", "[Ezreal] Kill Steal Settings")
EzrealMenu.KS:Boolean("Q", "Use Q", true)
EzrealMenu.KS:Boolean("W", "Use W", true)
EzrealMenu.KS:Boolean("R", "Use R", true)
-- [[Draw]]
EzrealMenu:SubMenu("Draw", "[Ezreal] Drawing Settings")
EzrealMenu.Draw:Boolean("Q", "Draw Q", false)
EzrealMenu.Draw:Boolean("W", "Draw W", false)
EzrealMenu.Draw:Boolean("E", "Draw E", false)
EzrealMenu.Draw:Boolean("Disable", "Disable All Drawings", false)

-- [[ Spell details]]
local Spells = {
	Q = {range = 1150, delay = 0.25 , speed= 2000 , width = 60},
	W = {range = 1000, delay = 0.25 , speed= 1600 , width = 80},
	E = {range = 475, delay = 0.25 , speed= 2000 , width = 80},
	R = {range = 8000, delay = 1.0 , speed= 2000 , width = 160},
}
-- [[ Orbwalker ]]
function Mode()
	if _G.IOW_Loaded and IOW:Mode() then
		return IOW:Mode()
	elseif _G.PW_Loaded and PW:Mode() then
		return PW:Mode()
	elseif _G.DAC_Loaded and DAC:Mode() then
		return DAC:Mode()
	elseif _G.AutoCarry_Loaded and DACR:Mode() then
		return DACR:Mode()
	elseif _G.SLW_Loaded and SLW:Mode() then
		return SLW:Mode()
	end
end

-- [[ Tick ]]
OnTick(function()
	KS()
	target = GetCurrentTarget()
			 Combo()
			 Harass()
			 Farm()
		end)
-- [[ Ezreal Q ]]
function EzrealQ()
	local QPred = GetPrediction(target, Spells.Q)
	if QPred.hitChance > 0.4 then
		CastSkillShot(_Q, QPred.castPos)
	end
end
-- [[ Ezreal W ]]
function EzrealW()
	local WPred = GetPrediction(target, Spells.W)
	if WPred.hitChance > 0.3 then
		CastSkillShot(_W, WPred.castPos)
	end
end
-- [[ Ezreal E ]]
function EzrealE()
	local EPred = GetPrediction(target, Spells.E)
	if EPred.hitChance > 0.3 then
		CastSkillShot(_E, EPred.castPos)
	end	
end
-- [[ Ezreal R ]]
function EzrealR()
	local RPred = GetPrediction(target, Spells.R)
	if RPred.hitChance > 0.8 then
		CastSkillShot(_R, RPred.castPos)
	end
end


-- [[ Combo ]]
function Combo()
	if Mode() == "Combo" then
--		[[ Use Q ]]   		
		if EzrealMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
			EzrealQ()
			end	
--		[[ Use W ]]   		
		if EzrealMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, Spells.W.range) then
			EzrealW()
			end
--		[[ Use E ]]   		
		if EzrealMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, Spells.E.range) then
			EzrealE()
		end
	end
end

-- [[ Harass ]]
function Harass()
	if Mode() == "Harass" then
		if (myHero.mana/myHero.maxMana >= EzrealMenu.Harass.Mana:Value() /100) then
-- 			[[ Use Q ]]
			if EzrealMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
				EzrealQ()
			end
-- 			[[ Use W ]]
			if EzrealMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, Spells.W.range) then
				EzrealW()
			end
		end
	end
end
-- [[ LaneClear ]]
function Farm()
	if Mode() == "LaneClear" then
		if (myHero.mana/myHero.maxMana >= EzrealMenu.Farm.Mana:Value() /100) then
--			[[ Lane ]]
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
--					[[ Use Q ]]
					if EzrealMenu.Farm.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
							CastSkillShot(_Q, minion)
						end
					end
--					[[ Q For Last Hit]]
					if EzrealMenu.Farm.Q:Value() and Ready(_Q) and ValidTarget(minion, Spells.Q.range) then
						if GetCurrentHP(minion) < getdmg("Q", minion, myHero) then
							CastSkillShot(_Q,minion)
						end
					end
				end
--			[[ Jungle ]]
			for _, mob in pairs(minionManager.objects) do
				if GetTeam(mob) == MINION_JUNGLE then
--					[[ Use Q]]
					if EzrealMenu.Farm.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
							CastSkillShot(_Q, mob)
						end
					end	
				end
			end
		end
	end
-- [[ KillSteals ]]
function KS()
	for _, enemy in pairs(GetEnemyHeroes()) do
--		[[ Use Q ]]
		if EzrealMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy, Spells.Q.range) then
			if GetCurrentHP(enemy) < getdmg("Q", enemy, myHero) then
				EzrealQ()
				end
			end
--		[[ Use W ]]
		if EzrealMenu.KS.W:Value() and Ready(_W) and ValidTarget(enemy, Spells.W.range) then
			if GetCurrentHP(enemy) < getdmg("W", enemy, myHero) then
				EzrealW()
				end
			end
--		[[ Use R ]]
		if EzrealMenu.KS.R:Value() and Ready(_R) and ValidTarget(enemy, Spells.R.range) then
			if GetCurrentHP(enemy) < getdmg("R", enemy, myHero) then
				EzrealR()
				EzrealScriptPrint("KillSteals Ready")
				end
			end
		end
	end
-- [[ HP bar ]]
local function Ezreal_GetHPBarPos(enemy)
  local barPos = GetHPBarPos(enemy) 
  local BarPosOffsetX = -50
  local BarPosOffsetY = 46
  local CorrectionY = 39
  local StartHpPos = 31 
  local StartPos = Vector(barPos.x , barPos.y, 0)
  local EndPos = Vector(barPos.x + 108 , barPos.y , 0)    
  return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

local function Ezreal_DrawLineHPBar(damage, text, unit, team)
  if unit.dead or not unit.visible then return end
  local p = WorldToScreen(0, Vector(unit.x, unit.y, unit.z))
  local thedmg = 0
  local line = 2
  local linePosA  = { x = 0, y = 0 }
  local linePosB  = { x = 0, y = 0 }
  local TextPos   = { x = 0, y = 0 }

  if damage >= unit.health then
    thedmg = unit.health - 1
    text = "KILLABLE!"
  else
    thedmg = damage
    text = "Possible Damage"
  end

  thedmg = math.round(thedmg)

  local StartPos, EndPos = Ezreal_GetHPBarPos(unit)
  local Real_X = StartPos.x + 24
  local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
  if Offs_X < Real_X then Offs_X = Real_X end 
  local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
  if mytrans >= 255 then mytrans=254 end
  local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
  if my_bluepart >= 255 then my_bluepart=254 end

  if team then
    linePosA.x = Offs_X - 24
    linePosA.y = (StartPos.y-(30+(line*15)))    
    linePosB.x = Offs_X - 24 
    linePosB.y = (StartPos.y+10)
    TextPos.x = Offs_X - 20
    TextPos.y = (StartPos.y-(30+(line*15)))
  else
    linePosA.x = Offs_X-125
    linePosA.y = (StartPos.y-(30+(line*15)))    
    linePosB.x = Offs_X-125
    linePosB.y = (StartPos.y-15)


    TextPos.x = Offs_X-122
    TextPos.y = (StartPos.y-(30+(line*15)))
  end

  DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
  DrawText(tostring(thedmg).." "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
end

-- [[ Drawings ]]
OnDraw(function(myHero)
	if myHero.dead or EzrealMenu.Draw.Disable:Value() then return end   
	local pos = GetOrigin(myHero)
--	[[ Draw Q ]]
	if EzrealMenu.Draw.Q:Value() then DrawCircle(pos, Spells.Q.range, 0, 25, GoS.Red) end
--	[[ Draw W ]]
	if EzrealMenu.Draw.W:Value() then DrawCircle(pos, Spells.W.range, 0, 25, GoS.Blue) end
--	[[ Draw Q]]
	if EzrealMenu.Draw.E:Value() then DrawCircle(pos, Spells.E.range, 0, 25, GoS.Green) end
end)

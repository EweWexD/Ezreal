--╔═══╗╔══╗╔═╗╔═╗╔═══╗╔╗   ╔═══╗     ╔═══╗╔════╗╔═══╗╔═══╗╔═══╗╔╗
--║╔═╗║╚╣─╝║║╚╝║║║╔═╗║║║   ║╔══╝     ║╔══╝╚══╗═║║╔═╗║║╔══╝║╔═╗║║║
--║╚══╗ ║║ ║╔╗╔╗║║╚═╝║║║   ║╚══╗     ║╚══╗  ╔╝╔╝║╚═╝║║╚══╗║║ ║║║║  
--╚══╗║ ║║ ║║║║║║║╔══╝║║ ╔╗║╔══╝     ║╔══╝ ╔╝╔╝ ║╔╗╔╝║╔══╝║╚═╝║║║ ╔╗
--║╚═╝║╔╣─╗║║║║║║║║   ║╚═╝║║╚══╗     ║╚══╗╔╝═╚═╗║║║╚╗║╚══╗║╔═╗║║╚═╝║
--╚═══╝╚══╝╚╝╚╝╚╝╚╝   ╚═══╝╚═══╝     ╚═══╝╚════╝╚╝╚═╝╚═══╝╚╝ ╚╝╚═══╝
-- V1.02 Changelog
-- +Autoupdate added.
--
-- V1.01 Changelog
-- +Q Error fix
-- range color changes
--
-- V1 released to GoS





--  [[ Champion ]]
if GetObjectName( GetMyHero()) ~= "Ezreal" then return end


-- [[ Lib ]]
require ("OpenPredict")
require ("DamageLib")
function EzrealScriptPrint(msg)
	print("<font color=\"#00ffff\">Ezreal Script:</font><font color=\"#ffffff\"> "..msg.."</font>")

end
EzrealScriptPrint("Made by EwEwe")

-- [[ Update ]]
local version = "1.0"
function AutoUpdate(data)

    if tonumber(data) > tonumber(version) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/Ezreal/master/Ezreal.lua", SCRIPT_PATH .. "Ezreal.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/EweWexD/Ezreal/master/Ezreal.version", AutoUpdate)
	


-- [[ Menu ]]
local EzrealMenu = Menu("Ezreal", "Simple Ezreal")
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
	Q = {range = 1100, delay = 0.25 , speed= 2000 , width = 60},
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
	local QPred = GetLinearAOEPrediction(target,Spells.Q)
	if QPred.hitChance > 0.9 then
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
		if EzrealMenu.Farm.Q:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Farm.Mana:Value() then
						if ValidTarget(minion, Spells.Q.range) then
							if CanUseSpell(myHero,_Q) == READY then
								CastSkillShot(_Q, GetOrigin(minion))
							end
						end
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

-- [[ Drawings ]]
OnDraw(function(myHero)
	if myHero.dead or EzrealMenu.Draw.Disable:Value() then return end   
	local pos = GetOrigin(myHero)
--	[[ Draw Q ]]
	if EzrealMenu.Draw.Q:Value() then DrawCircle(pos, Spells.Q.range, 1, 25, 0xFFC2C244) end
--	[[ Draw W ]]
	if EzrealMenu.Draw.W:Value() then DrawCircle(pos, Spells.W.range, 1, 25, 0xFFFFFF00) end
--	[[ Draw Q]]
	if EzrealMenu.Draw.E:Value() then DrawCircle(pos, Spells.E.range, 0, 25, 0xFF56B107) end
end)

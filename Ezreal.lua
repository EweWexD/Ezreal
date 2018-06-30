--╔═══╗╔══╗╔═╗╔═╗╔═══╗╔╗   ╔═══╗     ╔═══╗╔════╗╔═══╗╔═══╗╔═══╗╔╗
--║╔═╗║╚╣─╝║║╚╝║║║╔═╗║║║   ║╔══╝     ║╔══╝╚══╗═║║╔═╗║║╔══╝║╔═╗║║║
--║╚══╗ ║║ ║╔╗╔╗║║╚═╝║║║   ║╚══╗     ║╚══╗  ╔╝╔╝║╚═╝║║╚══╗║║ ║║║║  
--╚══╗║ ║║ ║║║║║║║╔══╝║║ ╔╗║╔══╝     ║╔══╝ ╔╝╔╝ ║╔╗╔╝║╔══╝║╚═╝║║║ ╔╗
--║╚═╝║╔╣─╗║║║║║║║║   ║╚═╝║║╚══╗     ║╚══╗╔╝═╚═╗║║║╚╗║╚══╗║╔═╗║║╚═╝║
--╚═══╝╚══╝╚╝╚╝╚╝╚╝   ╚═══╝╚═══╝     ╚═══╝╚════╝╚╝╚═╝╚═══╝╚╝ ╚╝╚═══╝
-- V1.05 Changelog
-- +Now some items are used (BOTRK, Hextech Gunblade and Bilfewater Cutlass) automatically in the tf.
--
-- V1.04 Changelog
-- +GoSPred has been added to choose the predictions of Q, W and R.
-- +Auto Q/W added.
--
-- V1.031 Changelog
-- +Small bugs fixed.
--
-- V1.03 Changelog
-- +Autolevel R>Q>W>E on/off added
--
-- V1.02 Changelog
-- +Autoupdate added.
--
-- V1.01 Changelog
-- +Q Error fix
-- +range color changes
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
EzrealScriptPrint("Made by EweEwe")

-- [[ Update ]]
local version = "1.05"
function AutoUpdate(data)

    if tonumber(data) > tonumber(version) then
        PrintChat("<font color='#00ffff'>New version found!"  .. data)
        PrintChat("<font color='#00ffff'>Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/Ezreal/master/Ezreal.lua", SCRIPT_PATH .. "Ezreal.lua", function() PrintChat("<font color='#00ffff'>Update Complete, please 2x F6!") return end)
    else
        PrintChat("<font color='#00ffff'>No updates found!")
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
-- [[ AutoAB ]]
EzrealMenu:SubMenu("AutoAB", "[Ezreal] Auto Q & W")
EzrealMenu.AutoAB:Boolean("Q", "Auto Q", true)
EzrealMenu.AutoAB:Boolean("W", "Auto W", true)
EzrealMenu.AutoAB:Slider("Mana", "Min. Mana", 50, 0, 100, 1)
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
-- [[ AutoLevel ]]
EzrealMenu:SubMenu("AutoLevel", "[Ezreal] AutoLevel")
EzrealMenu.AutoLevel:Boolean("DisableAUTOMAX", "Auto max abilities R>Q>W>E?", false)
-- [[ Prediction ]]
EzrealMenu:SubMenu("Prediction", "[Ezreal] Prediction Settings")
EzrealMenu.Prediction:DropDown("QPrediction","Prediction of Q", 2, {"OpenPredict", "GoSPrediction"})
EzrealMenu.Prediction:DropDown("WPrediction","Prediction of W", 2, {"OpenPredict", "GoSPrediction"})
EzrealMenu.Prediction:DropDown("RPrediction","Prediction of R", 2, {"OpenPredict", "GoSPrediction"})
-- [[Draw]]
EzrealMenu:SubMenu("Draw", "[Ezreal] Drawing Settings")
EzrealMenu.Draw:Boolean("Q", "Draw Q", false)
EzrealMenu.Draw:Boolean("W", "Draw W", false)
EzrealMenu.Draw:Boolean("E", "Draw E", false)
EzrealMenu.Draw:Boolean("Disable", "Disable All Drawings", false)
-- [[ Item Use ]]
EzrealMenu:SubMenu("Items", "[Ezreal] Items Use")
EzrealMenu.Items:Boolean("BOTRK", "Use BOTRK", true)
EzrealMenu.Items:Boolean("HG", "Use Hextech Gunblade", true)
EzrealMenu.Items:Boolean("BC", "Use Bilfewater Cutlass", true)

-- [[ AutoLevel ]]
local levelsc =  { _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E }

-- [[ Spell details]]
local Spells = {
	Q = {range = 1150, delay = 0.25 , speed= 2000 , width = 60, collision = true, col = {"minion", "yasuowall"}},
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
	elseif GoSWalkLoaded and GoSWalk.CurrentMode then
		return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
	end
end

-- [[ Tick ]]
OnTick(function()
	AutoLevel()
	target = GetCurrentTarget()
			 KS()
			 Combo()
			 Harass()
			 Farm()
			 AutoAB()
			 Items()
		end)

-- [[ AutoLevel ]]
function AutoLevel()
	if EzrealMenu.AutoLevel.DisableAUTOMAX:Value() then return end
	if GetLevelPoints(myHero) > 0 then
		DelayAction(function() LevelSpell(levelsc[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
	end
end

-- [[ Ezreal Q ]]
function EzrealQ()
	if GetDistance(target) < Spells.Q.range then
		if EzrealMenu.Prediction.QPrediction:Value() == 1 then
			local QPred = GetLinearAOEPrediction(target,Spells.Q)
			if QPred.hitChance > 0.9 then
				CastSkillShot(_Q, QPred.castPos)
			end
		elseif EzrealMenu.Prediction.QPrediction:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),Spells.Q.speed, Spells.Q.delay*1000,Spells.Q.range,Spells.Q.width,true,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		end
	end
end
-- [[ Ezreal W ]]
function EzrealW()
	if GetDistance(target) < Spells.W.range then
		if EzrealMenu.Prediction.WPrediction:Value() == 1 then
			local WPred = GetPrediction(target, Spells.W)
			if WPred.hitChance > 0.3 then
				CastSkillShot(_W, WPred.castPos)
			end
		elseif EzrealMenu.Prediction.WPrediction:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),Spells.W.speed, Spells.W.delay*1000,Spells.W.range,Spells.W.width,false,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end	
		end
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
	if EzrealMenu.Prediction.RPrediction:Value() == 1 then
		local RPred = GetPrediction(target, Spells.R)
		if RPred.hitChance > 0.8 then
			CastSkillShot(_R, RPred.castPos)
		end
		elseif EzrealMenu.Prediction.RPrediction:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),Spells.R.speed,Spells.R.delay*1000,Spells.R.range,Spells.R.width,false,true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
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
		if EzrealMenu.Combo.E:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, Spells.E.range+GetRange(myHero)) then
					CastSkillShot(_E, GetMousePos())
				end
			end
		end
	end
end
-- [[ Items Use ]]
function Items()
	if Mode() == "Combo" then
		if EzrealMenu.Items.BOTRK:Value() then
			if GetItemSlot(myHero, 3153) >= 1 and ValidTarget(target, 550) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3153)) then
					CastTargetSpell(target, GetItemSlot(myHero, 3153))
				end
			end
		end
		if EzrealMenu.Items.HG:Value() then
			if GetItemSlot(myHero, 3146) >= 1 and ValidTarget(target, 700) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3146)) then
					CastTargetSpell(target, GetItemSlot(myHero, 3146))
				end
			end
		end
		if EzrealMenu.Items.BC:Value() then
			if GetItemSlot(myHero, 3144) >= 1 and ValidTarget(target, 550) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3144)) then
					CastTargetSpell(target, GetItemSlot(myHero, 3144))
				end
			end
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
-- [[ AutoAB ]]
function AutoAB()
	if EzrealMenu.AutoAB.Q:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.AutoAB.Mana:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, Spells.Q.range) then
					EzrealQ(target)
				end
			end
		end
	end
	if EzrealMenu.AutoAB.W:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.AutoAB.Mana:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, Spells.W.range) then
					EzrealW(target)
				end
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

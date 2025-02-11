-- WoW Addon: valMagePack
-- Module: Buff Tracker
local addonName, valMagePack = ...
valMagePack = valMagePack or {}
local BuffTracker = {}

-- Spell Table
local SPELL_IDS = {
   AETHERVISION_ID = 391095,
   ARCANE_BARRAGE_ID = 44425,
   ARCANE_SURGE_ID = 365350,
   COLD_FRONT_ID = 386653,
   FLURRY_ID = 44614,
   ICY_VEINS_ID = 12472,
   SHIFTING_POWER_ID = 382440
}

-- Helper function to get all spell charges and cooldowns
local function GetSpellInfo(spellID)
   local charges, maxCharges, start, rechargeDuration = GetSpellCharges(spellID)
   local cooldown = 0

   if start and rechargeDuration then
      cooldown = rechargeDuration - (GetTime() - start)
      if cooldown < 0 then
         cooldown = 0
      end
   end

   charges = charges or 0
   return charges, maxCharges, cooldown
end

-- Create Buff Tracker container
local buffContainer = CreateFrame("Frame", "BuffContainerFrame", UIParent)
buffContainer:SetSize(300, 64)
buffContainer:setPoint("CENTER", 0, 30)

-- Buff icon table for dynamic tracking
local trackedBuffs = {}

local function CreateBuffDisplay(name, spellID)
   local buffFrame = CreateFrame("Frame", nil, buffContainer)
   buffFrame:SetSize(30, 30)

   local icon = buffFrame:CreateTexture(nil, "ARTWORK")
   icon:SetAllPoints()
   icon:SetTexture("Interface\\Icons\\inv_misc_questionmark") -- Placeholder: Messing around w/ dynamic icons

   local text = buffFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
   text:SetPoint("TOP", buffFrame, "BOTTOM", 0, -5)
   text:SetText("") -- Dynamically updated
   text:SetTextColor(0.6, 0.4, 0.8) -- Purple(R,G,B)

   local LCG = LibStub("LibCustomGlow-1.0")

   function buffFrame:ShowGlow()
      LCG.PixelGlow_Start(self, {1, 0.5, 0.5, 1}, 12, 0.25, nil, 2, nil, nil, false)
   end

   function buffFrame:HideGlow()
      LCG.PixelGlow_Stop(self)
   end

   buffFrame.icon = icon
   buffFrame.text = text
   buffFrame.spellID = spellID
   buffFrame:Hide()
   return buffFrame
end

-- Initialize tracked buffs
function BuffTracker:InitializeBuffs()
   trackedBuffs["Aethervision"] = CreateBuffDisplay("Aethervision", SPELL_IDS.AETHERVISION_ID)
   trackedBuffs["ArcaneBarrage"] = CreateBuffDisplay("Arcane Barrage", SPELL_IDS.ARCANE_BARRAGE_ID)
   trackedBuffs["ShiftingPower"] = CreateBuffDisplay("Shifting Power", SPELL_IDS.SHIFTING_POWER_ID)
end

-- Update function for Arcane spec
local function UpdateArcaneStatus()
   local aetherCharges, _, aetherCD = GetSpellInfo(SPELL_IDS.AETHERVISION_ID)
   local surgeCD = select(3, GetSpellInfo(SPELL_IDS.ARCANE_SURGE_ID))
   local shiftingCD = select(3, GetSpellInfo(SPELL_IDS.SHIFTING_POWER_ID))
   local aetherFrame = trackedBuffs["Aethervision"]
   local barrageFrame = trackedBuffs["ArcaneBarrage"]
   local shiftingFrame = trackedBuffs["ShiftingPower"]

   if aetherCharges >= 1 then
      aetherFrame.icon:SetTexture("Interface\\Icons\\sha_ability_rogue_bloodyeye_nightborne")
      aetherFrame.text:SetText(aetherCharges)
      aetherFrame:Show()

      if aetherCharges == 2 then
         aetherFrame:ShowGlow()
         barrageFrame.icon:SetTexture("Interface\\Icons\\ability_mage_arcanebarrage")
         barrageFrame.text:SetText("Barrage!")
         barrageFrame:Show()
      else
         aetherFrame:HideGlow()
         barrageFrame:Hide()
      end
   else
      aetherFrame:Hide()
      barrageFrame:Hide()
   end     
   
   if surge
end

-- Main update function
function BuffTracker:UpdateSpecStatus()
   local currentSpec = GetSpecialization()

   if currentSpec == 1 then -- Arcane
      UpdateArcaneStatus()
   -- elseif currentSpec == 2 then -- Fire
   --    UpdateFireStatus()
   elseif currentSpect == 3 then -- Frost
      UpdateFrostStatus()
   end
end

-- Initialize start and update loops
function BuffTracker:OnLoad()
   self:InitializeBuffs()
   C_Timer.NewTicker(1, function() self:UpdateSpecStatus() end)
end

-- Register module
valMagePack.BuffTracker = BuffTracker
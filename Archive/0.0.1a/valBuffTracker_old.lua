local addonName, addonTable = ...
local MyAddon = addonTable[1]

-- BuffTracker Table
local BuffTracker = {}
MyAddon.BuffTracker = BuffTracker

-- Spell Table
local spellTable = {
   ARCANE_SURGE_ID = 365350,
   COLD_FRONT_ID = 386653,
   FLURRY_ID = 44614,
   ICY_VEINS_ID = 12472,
   SHIFTING_POWER_ID = 382440
}

-- Create Buff Tracker container
local buffContainer = CreateFrame("Frame", "BuffContainerFrame", UIParent)
buffContainer:SetSize(200, 64) -- Placeholder size - will expand dynamically
buffContainer:SetPoint("CENTER", 0, 30) -- Placeholder position - will expand dynamically
-- buffFrame:Hide()

-- Buff icon table for dynamic tracking
local trackedBuffs = {}

-- Helper function to create a buff display
local function CreateBuffDisplay(name, spellID)
   local buffFrame = CreateFrame("Frame", nil, buffContainer)
   buffFrame:SetSize(30, 30)

   local icon = buffFrame:CreateTexture(nil, "ARTWORK")
   icon:SetAllPoints()
   icon:SetTexture("Interface\\Icons\\ability_mage_shiftingpower")

   local text = buffFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
   text:SetPoint("TOP", buffFrame, "BOTTOM", 0, -5)
   text:SetText("") -- Dynamically updated
   text:SetTextColor(0.6, 0.4, 0.8) -- Purple color (R, G, B)

   local LCG = LibStub("LibCustomGlow-1.0")

   local function ShowGlow(frame)
      LCG.PixelGlow_Start(frame, {1, 0.5, 0.5, 1}, 12, 0.25, nil, 2, nil, nil, false)
   end

   local function HideGlow(frame)
      LCG.PixelGlow_Stop(frame)
   end

   -- Add these functions to your buff frame
   buffFrame.ShowGlow = function(self) ShowGlow(self) end
   buffFrame.HideGlow = function(self) HideGlow(self) end

   -- local glow = CreateFrame("Frame", nil, buffFrame, "ActionButtonSpellActivationAlert")
   -- glow:SetAllPoints(buffFrame)
   -- glow:Hide()

   buffFrame.icon = icon
   buffFrame.text = text
   buffFrame.glow = glow
   buffFrame.spellID = spellID
   return buffFrame
end

-- Add texture to buff icon
-- local icon = buffFrame:CreateTexture(nil, "ARTWORK")
-- icon:SetAllPoints()
-- icon:SetTexture("Interface\\Icons\\inv_ability_mage_shiftingpower")

-- Add text to frame
-- local text = buffFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
-- text:SetPoint("BOTTOM", buffFrame, "TOP", 0, 10)
-- text:SetText("Shifting Power!")

-- Add glow effect
-- local glow = CreateFrame("Frame", nill, buffFrame, "ActionButtonSpellActivationAlert")
-- glow:SetAllPoints(buffFrame)
-- glow:Hide()

-- Flurry Info
local function GetFlurryInfo()
   -- Get Flurry CD
   -- local flurryCD = 0
   -- local start, duration, enable = GetSpellCooldown(spellTable.FLURRY_ID)
   -- if enable == 1 and start > 0 and duration > 0 then
   --    flurryCd = (start + duration) - GetTime()
   -- end

   -- Get Flurry Charges
   -- local flurryCharges = 0
   -- local charges, maxCharges, rechargeStart, rechargeDuration = GetSpellCharges(spellTable.FLURRY_ID)
   -- if charges then
   --    flurryCharges = charges
   -- end

   local flurryCharges, maxFlurryCharges, flurryRechargeStart, flurryRechargeDuration = GetSpellCharges(spellTable.FLURRY_ID)
   local flurryCD = nil

   if flurryRechargeStart and flurryRechargeDuration then
      flurryCD = flurryRechargeDuration - (GetTime() - flurryStart)
      if flurryCD < 0 then
         flurryCD = 0 -- Ensure CD is never negative
      end
   else
      flurryCD = 0 -- Default no CD
   end

   -- Ensure flurryCharges is always valid
   if not flurryCharges then
      flurryCharges = 0
   end

   return flurryCd, flurryCharges
end

-- Helper to calculate triggers
local function CheckTriggers()
   -- local arcaneSurgeRemaining = select(6, UnitBuff("player", "Arcane Surge")) -- Get remaining time
   -- local icyVeinsRemaining = select(6, UnitBuff("player", "Arcane Surge")) -- Get remaining time
   -- local arcaneSurgeCD = GetSpellCooldown(spellTable.ARCANE_SURGE_ID)
   -- local icyVeinsCD = GetSpellCoolDown(spellTable.ICY_VEINS_ID)
   -- local shiftingPowerCD = GetSpellCooldown(spellTable.SHIFTING_POWER_ID)
   -- local flurryCD = GetSpellCooldown(spellTable.FLURRY_ID)
   -- local flurryCharges = GetSpellCharges(spellTable.FLURRY_ID)
   local isColdFrontKnown = IsPlayerSpell(spellTable.COLD_FRONT_ID)
   local flurryCD = GetFlurryInfo()
   local flurryCharges = GetFlurryInfo()

   -- Aura tracking
   -- arcaneSurgeRemaining process
   local arcaneSurgeRemaining
   for i = 1, 40 do
      local name, _, _, _, duration, expirationTime, _, _, _, spellId = UnitBuff("player", i)
      if name == "Arcane Surge" or spellID == spellTable.ARCANE_SURGE_ID then
         if duration and expirationTime then
            arcaneSurgeRemaining = expirationTime - GetTime() -- Calculate remaining time
         end
         break
      end
   end

   -- icyVeinsRemaining process
   local icyVeinsRemaining
   for i = 1, 40 do
      local name, _, _, _, duration, expirationTime, _, _, _, spellId = UnitBuff("player", i)
      if name == "Icy Veins" or spellID == spellTable.ICY_VEINS_ID then
         if duration and expirationTime then
            arcaneSurgeRemaining = expirationTime - GetTime() -- Calculate remaining time
         end
         break
      end
   end

   -- Cooldown Tracking
   -- shiftingPowerCD process
   local shiftingPowerCD = 0
   local start, duration, enable = GetSpellCooldown(spellTable.SHIFTING_POWER_ID)
   if enable == 1 and start > 0 and duration > 0 then
      shiftingPowerCD = (start + duration) - GetTime() -- Calculate remaining CD
   end

   -- arcaneSurgeCD process
   local arcaneSurgeCD = 0
   local start, duration, enable = GetSpellCooldown(spellTable.ARCANE_SURGE_ID)
   if enable == 1 and start > 0 and duration > 0 then
      arcaneSurgeCD = (start + duration) - GetTime() -- Calculate remaining CD
   end

   -- icyVeinsCD process
   local icyVeinsCD = 0
   local start, duration, enable = GetSpellCooldown(spellTable.ICY_VEINS_ID)
   if enable == 1 and start > 0 and duration > 0 then
      icyVeinsCD = (start + duration) - GetTime() -- Calculate remaining CD
   end

   -- flurryCD process
   -- local flurryCD = 0
   -- local start, duration, enable = GetSpellCooldown(spellTable.FLURRY_ID)
   -- if enable == 1 and start > 0 and duration > 0 then
   --    flurryCD = (start + duration) - GetTime() -- Calculate remaining CD
   -- end

   -- Charges Tracking

   -- Trigger 1: Arcane Surge
   local trigger1 = (arcaneSurgeRemaining and arcaneSurgeRemaining <= 2 or not arcaneSurgeCD == 0)

   -- Trigger 2: Cold Front
   local trigger2 = isColdFrontKnown and (
      (icyVeinsRemaining and icyVeinsRemaining <= 2 or not icyVeinsCD == 0) and
      (flurryCharges <= 0 and not flurryCD == 0)
   )

   -- Trigger 3: Icy Veins w/o Cold Front
   local trigger3 = not isColdFrontKnown and (
      (icyVeinsRemaining and icyVeinsRemaining <= 2 or not icyVeinsCD == 0)
   )

   return (trigger1 or trigger2 or trigger3), shiftingPowerCD
end

-- Update function to display or hide Shifting Power
local function UpdateShiftingPower()
   local shouldDisplay, shiftingPowerCD = CheckTriggers()
   local shiftingPowerFrame = trackedBuffs["Shifting Power"]

   if shouldDisplay and shiftingPowerCD == 0 then
      shiftingPowerFrame.icon:SetTexture("Interface\\Icons\\ability_mage_shiftingpower")
      shiftingPowerFrame.text:SetText("Shifting Power!")
      shiftingPowerFrame.glow:Show()
      shiftingPowerFrame:Show()
   else
      shiftingPowerFrame.icon:Hide()
      shiftingPowerFrame.text:Hide()
      shiftingPowerFrame.glow:Hide()
      shiftingPowerFrame:Hide()
   end
end

-- Function to update the display
-- function BuffTracker:UpdateBuffDisplay(spellID)
--    local name, _, iconTexture = UnitBuff("player", spellID)

--    if name then
--       icon:SetTexture(iconTexture)
--       buffFrame:Show()
--       glow:Show()
--       text:Show()
--    else
--       buffFrame:Hide()
--       glow:Hide()
--       text:Hide()
--    end
-- end

-- Event handler
-- local eventFrame = CreateFrame("Frame")
-- eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
-- eventFrame:SetScript("OnEvent", function(_, _, unit)
--    if unit == "player" then
--       BuffTracker:UpdateBuffDisplay(382440)
--    end
-- end)

-- Initialize the module
-- function BuffTracker:Initialize()
--    print("BuffTracker initialized")
-- end

-- Initialize Tracked Buffs
function BuffTracker:Initialize()
   -- Create Shifting Power display
   local shiftingPowerFrame = CreateBuffDisplay("Shifting Power", spellTable.SHIFTING_POWER_ID)
   trackedBuffs["Shifting Power"] = shiftingPowerFrame

   -- Positioning and dynamic expansion
   local numBuffs = 0
   for _, frame in pairs(trackedBuffs) do
      frame:ClearAllPoints()
      frame:SetPoint("CENTER", buffContainer, "CENTER", numBuffs * 70 - 35, 0) -- Dynamic layout
      numBuffs = numBuffs + 1
      frame:Hide()
   end

   -- Event handler for updates
   local eventFrame = CreateFrame("Frame")
   eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
   eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
   eventFrame:SetScript("OnEvent", UpdateShiftingPower)

   print("BuffTracker initialized")
end

MyAddon.BuffTracker:Initialize()
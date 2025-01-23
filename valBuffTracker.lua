local addonName, addonTable = ...
local MyAddon = addonTable[1]

-- Spell Table
local spellTable = {
   ARCANE_SURGE_ID = 365350,
   COLD_FRONT_ID = 386653,
   FLURRY_ID = 44614,
   ICY_VEINS_ID = 12472,
   SHIFTING_POWER_ID = 382440
}

-- BuffTracker Table
local BuffTracker = {}
MyAddon.BuffTracker = BuffTracker

-- Create frame for displaying buff(s)
local buffContainer = CreateFrame("Frame", "BuffDisplayFrame", UIParent)
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
   icon:SetTexture("Interface\\Icons\\inv_ability_mage_shiftingpower")

   local text = buffFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
   text:SetPoint("TOP", buffFrame, "BOTTOM", 0, -5)
   text:SetText("") -- Dynamically updated
   text:SetTextColor(0.6, 0.4, 0.8) -- Purple color (R, G, B)

   local glow = CreateFrame("Frame", nil, buffFrame, "ActionButtonSpellActivationAlerty")
   glow:SetAllPoints(buffFrame)
   glow:Hide()

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

-- Helper to calculate triggers
local function CheckTriggers()
   local arcaneSurgeRemaining = select(6, UnitBuff("player", "Arcane Surge")) -- Get remaining time
   local icyVeinsRemaining = select(6, UnitBuff("player", "Arcane Surge")) -- Get remaining time
   local arcaneSurgeCD = GetSPellCooldown(spellTable.ARCANE_SURGE_ID)
   local icyVeinsCD = GetSpellCoolDown(spellTable.ICY_VEINS_ID)
   local shiftingPowerCD = GetSpellCooldown(spellTable.SHIFTING_POWER_ID)
   local flurryCD = GetSpellCooldown(spellTable.FLURRY_ID)
   local flurryCharges = GetSpellCharges(spellTable.FLURRY_ID)
   local isColdFrontKnown = IsPlayerSpell(spellTable.COLD_FRONT_ID)

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

-- Function to update the display
function BuffTracker:UpdateBuffDisplay(spellID)
   local name, _, iconTexture = UnitBuff("player", spellID)

   if name then
      icon:SetTexture(iconTexture)
      buffFrame:Show()
      glow:Show()
      text:Show()
   else
      buffFrame:Hide()
      glow:Hide()
      text:Hide()
   end
end

-- Event handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
eventFrame:SetScript("OnEvent", function(_, _, unit)
   if unit == "player" then
      BuffTracker:UpdateBuffDisplay(382440)
   end
end)

-- Initialize the module
function BuffTracker:Initialize()
   print("BuffTracker initialized")
end
BuffTracker:Initialize()
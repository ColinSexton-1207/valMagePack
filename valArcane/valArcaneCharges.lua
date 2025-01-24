-- WoW Addon: valMagePack
-- Module: Arcane Charges
local addonName, addonTable = ...
local MyAddon = addonTable[2]

-- Arcane Charges Table
local ArcaneChargeTracker = {}
MyAddon.ArcaneChargeTracker = ArcaneChargeTracker

-- Constants
local MAGE_SPEC_ARCANE = 62 -- Spec ID for Arcane Mage
local ARCANE_CHARGES_POWER_TYPE = 16 -- Power type ID for Arcane Charges
local ARCANE_CHARGES_SPELL_ID = 36032 -- Spell ID for Arcane Charges

-- Utility Function(s)
-- For testing purposes only!
local function PrintDebug(message)
   DEFAULT_CHAT_FRAME:AddMessage("[ClassPack] " .. message) -- Output message to chat panel
end

-- Create Arcane Charge Bar container
local arcaneChargeContainer = CreateFrame("Frame", nil, UIParent)
arcaneChargeContainer:SetSize(300, 12.5)
arcaneChargeContainer:SetPoint("CENTER", UIParent, "CENTER", 0, -150)

-- Capture module load event triggers
function ArcaneChargeTracker:OnLoad()
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
   self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
   self:RegisterEvent("UNIT_AURA")
   self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
   self:RegisterEvent("UNIT_POWER_UPDATE")

   self:CreateArcaneChargeBar()
   -- PrintDebug("Arcane Specialization Detected")
end

-- Helper function to create Arcane Charge bar
local function CreateArcaneChargeBar(name, spellID)
   self.ui = {}

   local arcaneChargeBarBG arcaneChargeContainer:CreateTexture(nil, "BACKGROUND")
   arcaneChargeBarBG:SetAllPoints(true)
   arcaneChargeBarBG:SetColorTexture(0.3, 0.3, 0.3, 0.5)

   self.ui["ChargeContainer"] = arcaneChargeContainer
   self.ui["ChargeBars"] = {}

   for i = 1, 4 do
      
end

-- Event Handler
function ArcaneChargeTracker:OnEvent(event, ...)
   if event == "PLAYER_ENTERING_WORLD" then
      self:CheckSpec()
   elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
      self:CheckSpec()
   elseif event == "UNIT_AURA" or event == "COMBAT_LOG_EVENT_UNFILTERED" then
      self:UpdateBuffsAndDebuffs()
   elseif event == "UNIT_POWER_UPDATE" then
      self:UpdateResources()
   end
end

-- Initialize Arcane Charge Module
function ArcaneChargeTracker:Initialize()
   -- Initialize load event tracking
   OnLoad()
   -- Initialize Event Handler
   OnEvent()
end

MyAddon.ArcaneChargeTracker:Initialize()
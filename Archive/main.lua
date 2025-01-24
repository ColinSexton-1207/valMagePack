-- WoW Addon: Class Pack Sandbox
local addonName, addonTable = ...
local ClassPack = CreateFrame("Frame")

-- Constants
local MAGE_SPEC_ARCANE = 62 -- Spec ID for Arcane Mage
local ARCANE_CHARGES_POWER_TYPE = 16 -- Power type for Arcane Charges (reference: Enum.PowerType)
local ARCANE_CHARGES_SPELL_ID = 36032 -- Spell ID for Arcane Charge

-- Utility Functions
local function PrintDebug(message)
   DEFAULT_CHAT_FRAME:AddMessage("[ClassPack] " .. message)
end

-- Initialization
function ClassPack:OnLoad()
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
   self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
   self:RegisterEvent("UNIT_AURA")
   self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
   self:RegisterEvent("UNIT_POWER_UPDATE")
   
   self:SetupUI()
   PrintDebug("Addon Loaded")
end

-- Event Handler
function ClassPack:OnEvent(event, ...)
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

-- Spec Check
function ClassPack:CheckSpec()
   local specID = GetSpecializationInfo(GetSpecialization())
   if specID == MAGE_SPEC_ARCANE then
      PrintDebug("Arcane Mage spec detected")
      self:EnableArcaneUI(true)
   else
      PrintDebug("Non-Arcane spec detected. Disabling tracking.")
      self:EnableArcaneUI(false)
   end
end

-- Enable/Disable UI Elements Based on Spec
function ClassPack:EnableArcaneUI(enable)
   if self.ui and self.ui["ChargeContainer"] then
      if enable then
         self.ui["ChargeContainer"]:Show()
      else
         self.ui["ChargeContainer"]:Hide()
      end
   end
end

-- Buff/Debuff Tracking
function ClassPack:UpdateBuffsAndDebuffs()
   local unit = "player"
   -- for i = 1, 40 do
   --    local name, _, _, _, duration, expierationTime, _, _, _, spellID = UnitAura(unit, i)
   --    if not name then break end
   AuraUtil.ForEachAura(unit, "HELPFUL", nil, function(name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellID)

      -- Example: Track Arcane Power (Replace w/ actual spell ID's as needed)
      --if spellID == 12042 then
      -- Stop early if Arcane Power is detected
      if spellID == ARCANE_CHARGES_SPELL_ID then
         PrintDebug("Arcane Power Active")
         self:UpdateUI("ArcanePower", duration, expirationTime)
         return true
      end
   end)
end

-- Resource Tracking
function ClassPack:UpdateResources()
   local charges = UnitPower("player", ARCANE_CHARGES_POWER_TYPE)
   --local maxCharges = UnitPower("player", ARCANE_CHARGES_POWER_TYPE)

   self:UpdateChargeBars(charges)
   PrintDebug("Arcane Charges: " .. charges)
   --self:UpdateUI("ArcaneCharges", charges, maxCharges)
   --PrintDebug("Arcane Charges: " .. charges .. "/" .. maxCharges)
end

-- UI Setup
function ClassPack:SetupUI()
   self.ui = {}

   -- Example: Arcane Charges Bar
   -- local bar = CreateFrame("StatusBar", nil, UIParent)
   -- bar:SetSize(300, 25)
   -- bar:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
   local container = CreateFrame("Frame", nil, UIParent)
   container:SetSize(300, 25)
   container:SetPoint("CENTER", UIParent, "CENTER", 0, -100)

   local bg = container:CreateTexture(nil, "BACKGROUND")
   bg:SetAllPoints(true)
   bg:SetColorTexture(0.3, 0.3, 0.3, 0.5)

   self.ui["ChargeContainer"] = container
   self.ui["ChargeBars"] = {}

   for i = 1, 4 do
      local bar = CreateFrame("StatusBar", nil, container)
      bar:SetSize(70, 25)
      bar:SetPoint("LEFT", container, "LEFT", (i - 1) * 75, 0)
      bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
      bar:GetStatusBarTexture():SetHorizTile(false)
      bar:SetStatusBarColor(0.5, 0, 0.8, 1)
      bar:Hide()

      table.insert(self.ui["ChargeBars"], bar)
   --bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
   --bar:GetStatusBarTexture():SetHorizTile(false)
   --bar:GetStatusBarColor(0.41, 0.8, 0.94)

   --local bg = bar:CreateTexture(nil, "BACKGROUND")
   --bg:SetAllPoints(true)
   --bg:SetColorTexture(0, 0, 0, 0.5)

   --local text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
   --text:SetPoint("CENTER")

   --self.ui["ArcaneCharges"] = {bar = bar, text = text}
   end
end

-- Charge Bar Updates
function ClassPack:UpdateChargeBars(charges)
   if not self.ui or not self.ui["ChargeBars"] then return end

   for i, bar in ipairs(self.ui["ChargeBars"]) do
      if i <= charges then
         bar:Show()
      else
         bar:Hide()
      end
   end
end

-- UI Updates
-- function ClassPack:UpdateUI(element, value, maxValue)
--    local uiElement = self.ui[element]
--    if uiElement then
--       if uiElement.bar then
--          uiElement.bar:SetMinMaxValues(0, maxValue or 1)
--          uiElement.bar:SetValue(value)
--       end
--       if uiElement.text then
--          uiElement.text:SetText(value .. (maxValue and (" / " .. maxValue) or ""))
--       end
--    end
-- end

-- Register Event Handlers
--ClassPack:SetScript("OnEvent", ClassPack.OnEvent)
ClassPack:SetScript("OnEvent", function(self, event, ...)
   if self[event] then
      self[event](self, ...)
   else
      self:OnEvent(event, ...)
   end
end)
ClassPack:OnLoad()
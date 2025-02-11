local valMagePack = valMagePack

-- Create the core UI
function valMagePack:CreateUI()
   local frame = CreateFrame("Frame", "BuffTrackerFrame", UIParent)
   frame:SetSize(300, 400)
   frame:SetPoint("CENTER", UIParent, "CENTER")
   frame:SetMovable(true)
   frame:EnableMouse(true)
   frame:RegisterForDrag("LeftButton")
   frame:SetScript("OnDragStart", frame.StartMoving)
   frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
   self.UI = frame

   -- Alerts (Layer 1)
   local alertFrame = CreateFrame("Frame", nil, frame)
   alertFrame:SetSize(50, 50)
   alertFrame:SetPoint("TOP", frame, "TOP", 0, -10)
   
   local icon = alertFrame:CreateTexture(nil, "ARTWORK")
   icon:SetAllPoints()
   alertFrame.icon = icon

   local text = alertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
   text:SetPoint("TOP", alertFrame, "BOTTOM", 0, -2)
   alertFrame.text = text
   alertFrame:Hide()
   self.UI.alertFrame = alertFrame

   -- Buff Tracking (Layer 2)
   self.UI.buffIcons = {}
   for i = 1, 6 do
      local buff = CreateFrame("Frame", nil, frame)
      buff:SetSize(40, 40)
      buff:SetPoint("TOP", frame, "TOP", (i - 3.5) * 40, -80)

      local icon = buff:CreateTexture(nil, "ARTWORK")
      icon:SetAllPoints()
      buff.icon = icon

      local count = buff:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -2, 2)
      buff.count = count
      buff:Hide()
      table.insert(self.UI.buffIcons, buff)
   end
   
   -- Hero Talent Tracker (Layer 3) - i.e. Splinters (Spellslinger)

   -- Arcane Charges (Layer 4)
   local chargeBar = CreateFrame("StatusBar", nil, frame)
   chargeBar:SetSize(200, 20)
   chargeBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
   chargeBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
   chargeBar:SetMinMaxValues(0, 4)
   chargeBar:SetValue(0)
   self.UI.arcaneChargeBar = chargeBar
end
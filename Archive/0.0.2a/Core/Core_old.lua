local valMagePack = {}
valMagePack.Modules = {}

-- Register namespace
valMagePack.Core = {}

-- Saved variables/defaults
valMagePackDB = valMagePackDB or {
   enabled = true,
   position = {x = 500, y = 300},
   size = {width = 200, height = 50}
}

-- Initialize the addon
function valMagePack:Initialize()
   print("valMagePack loaded!")

   -- Load modules
   valMagePack.Modules.Arcane.Arcane = valMagePack_LoadArcaneModule()
   valMagePack.Modules.Frost.Frost = valMagePack_LoadFrostModule()

   -- Register events
   valMagePack:RegisterEvents()
end

-- Register events
function valMagePack:RegisterEvents()
   local frame = CreateFrame("Frame")
   frame:SetScript("OnEvent", function(_, event, ...)
      if valMagePack[event] then
         valMagePack[event](valMagePack, ...)
      end
   end)
   frame:RegisterEvent("PLAYER_ENTERING_WORLD")
   frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
   frame:RegisterEvent("UNIT_AURA")
   frame:RegisterEvent("UNIT_POWER_UPDATE")
end

-- Event: Player entering the world
function valMagePack:PLAYER_ENTERING_WORLD()
   self:LoadSpecModule()
end

-- Event: Player specialization change
function valMagePack:PLAYER_SPECIALIZATION_CHANGED()
   self:LoadSpecModule()
end

-- Event: Active auras
function valMagePack:UNIT_AURA()
   self:LoadSpecModule()
end

-- Event: Player power changes (i.e. Arcane Charges)
function valMagePack:UNIT_POWER_UPDATE()
   self:LoadSpecModule()
end

-- Load appropriate spec module
function valMagePack:LoadSpecModule()
   local specID = GetSpecialization()
   if specID == 1 then -- Arcane
      valMagePack.Modules.Arcane.Arcane:Enable()
   elseif specID == 2 then -- Fire
      print("Fire spec is not yet supported.")
   elseif specID == 3 then -- Frost
      valMagePack.Modules.Frost.Frost:Enable()
   end
end

valMagePack:Initialize()
valMagePack = LibStub("AceAddon-3.0"):NewAddon("valMagePack", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0")

-- Default settings
local defaults = {
   profile = {
      position = {x = 500, y = 300},
      size - {width = 300, height = 400},
      alertsEnables = true,
      buffsEnabled = true,
      cooldownTracking = true,
   }
}

function valMagePack:OnInitialize()
   -- Load Settings
   self.db = LibStub("AceDB-3.0"):New("valMagePackDB", defaults)

   -- Initialize Modules
   self:InitializeModules()

   -- Register Configuration
   valMagePack:RegisterConfig()
end

function valMagePack:InitializeModules()
   self.Modules = {
      Arcane = valMagePack_LoadArcaneModule(),
      -- Fire = valMagePack_LoadFireModule(),
      Frost = valMagePack_LoadFrostModule(),
      Shared = valMagePack_LoadSharedModule()
   }
end
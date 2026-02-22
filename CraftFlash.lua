local addonName, ns = ...

-- Default config
local defaults = {
    -- Crafting
    craftComplete = true,
    craftProgress = true,
    craftETA = true,
    craftAutoClose = false,
    -- Alerts
    auctionSold = true,
    auctionOutbid = true,
    rareSpawn = true,
    summonRequest = true,
    readyCheck = true,
    resurrect = true,
    tradeRequest = true,
    bgQueuePop = true,
}

-- Shared notify helper
function CraftFlash_Notify()
    FlashClientIcon()
end

-- SavedVariables initialization
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon ~= addonName then return end

    if not CraftFlashDB then
        CraftFlashDB = {}
    end

    -- Fill in any missing defaults
    for key, value in pairs(defaults) do
        if CraftFlashDB[key] == nil then
            CraftFlashDB[key] = value
        end
    end

    self:UnregisterEvent("ADDON_LOADED")
end)

-- Slash commands (open config panel)
SLASH_CRAFTFLASH1 = "/craftflash"
SLASH_CRAFTFLASH2 = "/cf"
SlashCmdList["CRAFTFLASH"] = function()
    -- Double call is a Blizzard bug workaround to ensure the panel opens correctly
    InterfaceOptionsFrame_OpenToCategory("CraftFlash")
    InterfaceOptionsFrame_OpenToCategory("CraftFlash")
end

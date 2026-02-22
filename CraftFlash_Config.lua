local panel = CreateFrame("Frame", "CraftFlashConfigPanel", UIParent)
panel.name = "CraftFlash"

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("CraftFlash")

local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetText("Flash your taskbar for crafting completions and important game events.")

-- Checkbox factory
local function CreateToggle(parent, anchor, offsetY, dbKey, label)
    local cb = CreateFrame("CheckButton", "CraftFlash_Toggle_" .. dbKey, parent, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offsetY)
    cb.Text:SetText(label)

    cb:SetScript("OnShow", function(self)
        self:SetChecked(CraftFlashDB[dbKey])
    end)

    cb:SetScript("OnClick", function(self)
        CraftFlashDB[dbKey] = self:GetChecked() and true or false
    end)

    return cb
end

-- Section headers
local function CreateHeader(parent, anchor, offsetY, text)
    local header = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    header:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offsetY)
    header:SetText(text)
    return header
end

-- Crafting section
local craftHeader = CreateHeader(panel, subtitle, -16, "Crafting")
local cb1 = CreateToggle(panel, craftHeader, -4, "craftComplete", "Flash taskbar when a crafting batch completes")
local cb2 = CreateToggle(panel, cb1, -4, "craftProgress", "Show batch progress overlay (5/20 crafted)")
local cb3 = CreateToggle(panel, cb2, -4, "craftETA", "Show estimated time remaining")
local cb4 = CreateToggle(panel, cb3, -4, "craftAutoClose", "Auto-close tradeskill window when batch finishes")

-- Alerts section
local alertHeader = CreateHeader(panel, cb4, -16, "Alerts")
local cb5 = CreateToggle(panel, alertHeader, -4, "auctionSold", "Flash when an auction sells")
local cb7 = CreateToggle(panel, cb5, -4, "rareSpawn", "Flash when a rare spawn appears on nameplates")
local cb8 = CreateToggle(panel, cb7, -4, "summonRequest", "Flash on summon request")
local cb9 = CreateToggle(panel, cb8, -4, "readyCheck", "Flash on ready check")
local cb10 = CreateToggle(panel, cb9, -4, "resurrect", "Flash on resurrect request")
local cb11 = CreateToggle(panel, cb10, -4, "tradeRequest", "Flash when a trade window opens")
local cb12 = CreateToggle(panel, cb11, -4, "bgQueuePop", "Flash when a battleground queue pops")

-- Register with Interface Options (handle both old and new API)
if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
    -- Store for slash command
    CraftFlash_SettingsCategory = category
else
    InterfaceOptions_AddCategory(panel)
end

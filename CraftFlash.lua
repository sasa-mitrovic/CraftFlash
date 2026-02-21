local addonName, ns = ...

local isCrafting = false
local batchTimer = nil
local craftCount = 0

-- Seconds to wait after last successful craft before assuming the batch is done
local BATCH_DELAY = 1.5

local frame = CreateFrame("Frame")

local function IsTradeskillOpen()
    -- TradeSkillFrame: most professions (Alchemy, Blacksmithing, Tailoring, etc.)
    -- CraftFrame: Enchanting (and Beast Training in Classic)
    return (TradeSkillFrame and TradeSkillFrame:IsShown())
        or (CraftFrame and CraftFrame:IsShown())
end

local function CancelBatchTimer()
    if batchTimer then
        batchTimer:Cancel()
        batchTimer = nil
    end
end

local function OnBatchDone()
    CancelBatchTimer()
    if craftCount > 0 then
        FlashClientIcon()
    end
    isCrafting = false
    craftCount = 0
end

local function ResetBatchTimer()
    CancelBatchTimer()
    batchTimer = C_Timer.NewTimer(BATCH_DELAY, OnBatchDone)
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "UNIT_SPELLCAST_START" then
        local unitTarget = ...
        if unitTarget == "player" and IsTradeskillOpen() then
            isCrafting = true
            CancelBatchTimer()
        end

    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTarget = ...
        if unitTarget == "player" and isCrafting then
            craftCount = craftCount + 1
            ResetBatchTimer()
        end

    elseif event == "UNIT_SPELLCAST_FAILED"
        or event == "UNIT_SPELLCAST_INTERRUPTED" then
        local unitTarget = ...
        if unitTarget == "player" and isCrafting then
            OnBatchDone()
        end

    elseif event == "UI_ERROR_MESSAGE" then
        local _, message = ...
        if isCrafting and message == ERR_INV_FULL then
            OnBatchDone()
        end
    end
end)

frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("UI_ERROR_MESSAGE")

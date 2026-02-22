local isCrafting = false
local batchTimer = nil
local craftCount = 0
local totalQueued = 0
local castDuration = 0

-- Seconds to wait after last successful craft before assuming the batch is done
local BATCH_DELAY = 1.5

-- Progress overlay frame
local overlay = CreateFrame("Frame", "CraftFlashOverlay", UIParent)
overlay:SetSize(200, 20)
overlay:Hide()

local overlayText = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
overlayText:SetAllPoints()
overlayText:SetJustifyH("CENTER")

local function AnchorOverlay()
    overlay:ClearAllPoints()
    if TradeSkillFrame and TradeSkillFrame:IsShown() then
        overlay:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -50)
        overlay:Show()
    elseif CraftFrame and CraftFrame:IsShown() then
        overlay:SetPoint("TOP", CraftFrame, "TOP", 0, -50)
        overlay:Show()
    else
        overlay:Hide()
    end
end

local function UpdateOverlay()
    if not CraftFlashDB.craftProgress then
        overlay:Hide()
        return
    end

    AnchorOverlay()

    local text = craftCount .. "/" .. totalQueued .. " crafted"

    if CraftFlashDB.craftETA and castDuration > 0 then
        local remaining = craftCount < totalQueued
            and (totalQueued - craftCount) * castDuration
            or 0
        if remaining > 0 then
            text = text .. " — ~" .. math.ceil(remaining) .. "s remaining"
        end
    end

    overlayText:SetText(text)
end

local function IsTradeskillOpen()
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

    if craftCount > 0 and CraftFlashDB.craftComplete then
        CraftFlash_Notify()
    end

    if CraftFlashDB.craftAutoClose then
        if TradeSkillFrame and TradeSkillFrame:IsShown() then
            CloseTradeSkill()
        end
        if CraftFrame and CraftFrame:IsShown() then
            CloseCraft()
        end
    end

    isCrafting = false
    craftCount = 0
    totalQueued = 0
    castDuration = 0
    overlay:Hide()
end

local function ResetBatchTimer()
    CancelBatchTimer()
    batchTimer = C_Timer.NewTimer(BATCH_DELAY, OnBatchDone)
end

local frame = CreateFrame("Frame")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "UNIT_SPELLCAST_START" then
        local unitTarget = ...
        if unitTarget == "player" and IsTradeskillOpen() then
            isCrafting = true
            CancelBatchTimer()

            -- Capture cast duration for ETA
            local _, _, _, startTimeMS, endTimeMS = UnitCastingInfo("player")
            if startTimeMS and endTimeMS then
                castDuration = (endTimeMS - startTimeMS) / 1000
            end

            -- Capture total queued count on first cast of a batch
            if craftCount == 0 then
                local repeatCount = GetTradeskillRepeatCount and GetTradeskillRepeatCount()
                if repeatCount and repeatCount > 0 then
                    totalQueued = repeatCount
                else
                    totalQueued = 1
                end
            end

            UpdateOverlay()
        end

    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTarget = ...
        if unitTarget == "player" and isCrafting then
            craftCount = craftCount + 1
            UpdateOverlay()
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

    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        if isCrafting then
            -- Window closed mid-batch, treat as done
            OnBatchDone()
        end
        overlay:Hide()
    end
end)

frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:RegisterEvent("CRAFT_CLOSE")

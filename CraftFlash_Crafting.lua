local isCrafting = false
local batchTimer = nil
local craftCount = 0
local totalQueued = 0
local castDuration = 0

-- Seconds to wait after last successful craft before assuming the batch is done
local BATCH_DELAY = 1.5

-- Progress overlay frame (created lazily once the tradeskill frame exists)
local overlay = nil
local overlayText = nil

local function GetOverlay()
    if overlay then return overlay end

    -- Parent to whichever tradeskill frame is available so it inherits strata/level
    local parent = TradeSkillFrame or CraftFrame or UIParent
    overlay = CreateFrame("Frame", "CraftFlashOverlay", parent)
    overlay:SetSize(250, 20)
    overlay:SetFrameStrata("HIGH")
    overlay:Hide()

    overlayText = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    overlayText:SetAllPoints()
    overlayText:SetJustifyH("CENTER")

    return overlay
end

local function AnchorOverlay()
    local ov = GetOverlay()
    ov:ClearAllPoints()
    if TradeSkillFrame and TradeSkillFrame:IsShown() then
        ov:SetParent(TradeSkillFrame)
        ov:SetPoint("BOTTOM", TradeSkillFrame, "TOP", 0, 4)
        ov:Show()
    elseif CraftFrame and CraftFrame:IsShown() then
        ov:SetParent(CraftFrame)
        ov:SetPoint("BOTTOM", CraftFrame, "TOP", 0, 4)
        ov:Show()
    else
        ov:Hide()
    end
end

local function UpdateOverlay()
    local ov = GetOverlay()
    if not CraftFlashDB.craftProgress then
        ov:Hide()
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
    GetOverlay():Hide()
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
        GetOverlay():Hide()
    end
end)

frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:RegisterEvent("CRAFT_CLOSE")

local frame = CreateFrame("Frame")

frame:SetScript("OnEvent", function(self, event, ...)
    -- Auction sold
    if event == "CHAT_MSG_SYSTEM" then
        local message = ...
        if CraftFlashDB.auctionSold and message:find(ERR_AUCTION_SOLD_S:gsub("%%s", ".+")) then
            CraftFlash_Notify()
        end

    -- Rare spawn detected via nameplate
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        if CraftFlashDB.rareSpawn then
            local unit = ...
            local classification = UnitClassification(unit)
            if classification == "rare" or classification == "rareelite" then
                CraftFlash_Notify()
            end
        end

    -- Summon request
    elseif event == "CONFIRM_SUMMON" then
        if CraftFlashDB.summonRequest then
            CraftFlash_Notify()
        end

    -- Ready check
    elseif event == "READY_CHECK" then
        if CraftFlashDB.readyCheck then
            CraftFlash_Notify()
        end

    -- Resurrect request
    elseif event == "RESURRECT_REQUEST" then
        if CraftFlashDB.resurrect then
            CraftFlash_Notify()
        end

    -- Trade window opened
    elseif event == "TRADE_SHOW" then
        if CraftFlashDB.tradeRequest then
            CraftFlash_Notify()
        end

    -- Battleground queue pop
    elseif event == "UPDATE_BATTLEFIELD_STATUS" then
        if CraftFlashDB.bgQueuePop then
            for i = 1, GetMaxBattlefieldID() do
                local status = GetBattlefieldStatus(i)
                if status == "confirm" then
                    CraftFlash_Notify()
                    return
                end
            end
        end
    end
end)

frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("CONFIRM_SUMMON")
frame:RegisterEvent("READY_CHECK")
frame:RegisterEvent("RESURRECT_REQUEST")
frame:RegisterEvent("TRADE_SHOW")
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

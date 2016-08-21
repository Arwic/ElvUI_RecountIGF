local frame = CreateFrame("Frame", "EUIRIGF_EVENTFRAME")
local inCombat = false
local hasTarget = false
local mouseOver = false

local function Update()
    if inCombat or hasTarget or mouseOver then
        --Recount.MainWindow:Show()
        Recount_MainWindow:SetAlpha(1.0)
    else
        --Recount.MainWindow:Hide()
        local globalFadeAlpha = ElvDB["profiles"]["TIM"]["actionbar"]["globalFadeAlpha"]
        Recount_MainWindow:SetAlpha(globalFadeAlpha)
    end
    print("DEBUG: inCombat, hasTarget, mouseOver = ", inCombat, hasTarget, mouseOver)
end

-- Handler
local function OnEventHandler(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then -- Enter combat
        inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then -- Leave combat
        inCombat = false
    elseif event == "PLAYER_TARGET_CHANGED" then -- Target changed
        if UnitName("target") == nil then -- Got a new target
            hasTarget = false
        else -- Lost our target
            hasTarget = true
        end
    elseif event == "!@#!@#---" then -- Losing health
        Recount.MainWindow:Show()
    end
    Update()
end

local function Recount_OnEnter(self, event, ...)
    mouseOver = true
end

local function Recount_OnLeave(self, event, ...)
    mouseOver = false
end

-- Register events
frame:RegisterEvent("PLAYER_REGEN_DISABLED") -- Enter combat
frame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Leave combat
frame:RegisterEvent("PLAYER_TARGET_CHANGED") -- Target changed
-- Mouse enter/leave
Recount_MainWindow:SetScript("OnEnter", Recount_OnEnter)
Recount_MainWindow:SetScript("OnLeave", Recount_OnLeave)
-- Register handlers
frame:SetScript("OnEvent", OnEventHandler) -- Generic handler
Update()
print("ElvUI_RecountIGF: Loaded")
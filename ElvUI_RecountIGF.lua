local frame = CreateFrame("Frame", "EUIRIGF_EVENTFRAME")
local inCombat = false
local hasTarget = false
local hasFocus = false
local mouseOver = false

local function Update()
    if inCombat or hasTarget or hasFocus or mouseOver then
        Recount_MainWindow:SetAlpha(1.0)
    else
        local globalFadeAlpha = ElvDB["profiles"]["TIM"]["actionbar"]["globalFadeAlpha"]
        Recount_MainWindow:SetAlpha(globalFadeAlpha)
    end
end

-- Handler
local function OnEventHandler(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then -- Enter combat
        inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then -- Leave combat
        inCombat = false
    elseif event == "PLAYER_TARGET_CHANGED" then -- Target changed
        if UnitExists("target") then -- Got new target
            hasTarget = true
        else -- Lost target
            hasTarget = false
        end
    elseif event == "PLAYER_FOCUS_CHANGED" then
        if UnitExists("focus") then -- Got new focus
            hasFocus = true
        else -- Lost focus
            hasFocus = false
        end
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
frame:RegisterEvent("PLAYER_FOCUS_CHANGED") -- Focus changed
-- Mouse enter/leave
Recount_MainWindow:SetScript("OnEnter", Recount_OnEnter)
Recount_MainWindow:SetScript("OnLeave", Recount_OnLeave)
-- Register handlers
frame:SetScript("OnEvent", OnEventHandler) -- Generic handler
Update()
print("ElvUI_RecountIGF: Loaded")
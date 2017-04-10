local eventFrame = CreateFrame("Frame", "EUIRIGF_EVENTFRAME")
local hoverFrame = CreateFrame("Frame", "EUIRIGF_HOVERFRAME")
local inCombat = false
local hasTarget = false
local hasFocus = false
local mouseOver = false

-- Returns the currently active ElvUI profile table
local function GetCurrentProfile()
    local charName = GetUnitName("player", false)
    local realmName = GetRealmName()
    local charNameRealm = charName .. " - " .. realmName
    for k, v in pairs(ElvDB["profileKeys"]) do
        if k == charNameRealm then
            return ElvDB["profiles"][v]
        end
    end
end

-- Updates the state of recount
local function Update()
    if inCombat or hasTarget or hasFocus or mouseOver then
        Recount_MainWindow:SetAlpha(1.0)
    else
        local globalFadeAlpha = GetCurrentProfile()["actionbar"]["globalFadeAlpha"]
        if globalFadeAlpha == nil then
            globalFadeAlpha = 0
        end
        Recount_MainWindow:SetAlpha(1.0 - globalFadeAlpha)
    end
end

-- Handlers
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
    Update()
end

local function Recount_OnLeave(self, event, ...)
    mouseOver = false
    Update()
end

-- Register events
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- Enter combat
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Leave combat
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED") -- Target changed
eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED") -- Focus changed
-- Mouse enter/leave
for _, child in ipairs({ Recount_MainWindow:GetChildren() }) do
    child:HookScript("OnEnter", Recount_OnEnter)
    child:HookScript("OnLeave", Recount_OnLeave)
end
Recount_MainWindow:SetScript("OnEnter", Recount_OnEnter)
Recount_MainWindow:SetScript("OnLeave", Recount_OnLeave)


-- Register handlers
eventFrame:SetScript("OnEvent", OnEventHandler) -- Generic handler
Update()
print("ElvUI_RecountIGF: Loaded")

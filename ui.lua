-- ui.lua
-- Nicolas's AJ — Luamor Classic style (Safe UI only)
-- Place as a LocalScript in StarterPlayer > StarterPlayerScripts (or use the loadstring loader)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent names (server can create/listen to these)
local REMOTE_ADD = "NicholasAJ_AddEntry"
local REMOTE_REMOVE = "NicholasAJ_RemoveEntry"
local REMOTE_REQUEST = "NicholasAJ_RequestJoin"

-- helper: ensure RemoteEvent exists (server may also set these up)
local function ensureRemote(name)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if obj and obj:IsA("RemoteEvent") then return obj end
    obj = Instance.new("RemoteEvent")
    obj.Name = name
    obj.Parent = ReplicatedStorage
    return obj
end

local remoteAdd = ensureRemote(REMOTE_ADD)
local remoteRemove = ensureRemote(REMOTE_REMOVE)
local remoteRequest = ensureRemote(REMOTE_REQUEST)

-- attribute helpers (persist across respawns)
local function setAttr(k,v) if player:GetAttribute(k) ~= v then player:SetAttribute(k,v) end end
local function getAttr(k,def) local v=player:GetAttribute(k) if v==nil then return def end return v end

-- defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.IgnoreList", nil) == nil then setAttr("NAJ.IgnoreList", "") end
if getAttr("NAJ.ThemeR", nil) == nil then
    local d = Color3.fromRGB(34, 106, 255)
    setAttr("NAJ.ThemeR", d.R); setAttr("NAJ.ThemeG", d.G); setAttr("NAJ.ThemeB", d.B)
end

-- create/reuse ScreenGui
local GUI_NAME = "NicholasAJ_UI_v2"
local screenGui = playerGui:FindFirstChild(GUI_NAME)
if screenGui and screenGui:IsA("ScreenGui") then
    -- reuse
else
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = GUI_NAME
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false -- persists after death
    screenGui.IgnoreGuiInset = true
end

-- clean children to avoid duplicates on re-run
for _,c in ipairs(screenGui:GetChildren()) do c:Destroy() end

-- layout constants for "Luamor Classic" style
local WIDTH, HEIGHT = 600, 360 -- chosen classic proportions
local LEFT_W = 220
local PADDING = 12

local function themeColor()
    local r = getAttr("NAJ.ThemeR", 34)
    local g = getAttr("NAJ.ThemeG", 106)
    local b = getAttr("NAJ.ThemeB", 255)
    return Color3.new(r, g, b)
end

-- Main container
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.08, 0)
main.AnchorPoint = Vector2.new(0.5,0)
main.BackgroundColor3 = Color3.fromRGB(18,20,26)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 12)
main.ClipsDescendants = true

-- Animated rainbow outline
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.LineJoinMode = Enum.LineJoinMode.Round
spawn(function()
    local hue = 0
    while main.Parent do
        hue = (hue + 0.006) % 1
        stroke.Color = Color3.fromHSV(hue, 0.85, 0.95)
        task.wait(0.02)
    end
end)

-- TOP BAR (header)
local top = Instance.new("Frame", main)
top.Name = "Top"
top.Size = UDim2.new(1,0,0,72)
top.Position = UDim2.new(0,0,0,0)
top.BackgroundColor3 = themeColor()
top.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", top); topCorner.CornerRadius = UDim.new(0, 12)

-- Title (top-left) "Nicolas's Autojoiner"
local title = Instance.new("TextLabel", top)
title.Name = "Title"
title.Size = UDim2.new(0, 280, 1, 0)
title.Position = UDim2.new(0, PADDING/2, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245,245,245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Nicolas's Autojoiner"

-- Discord under the title (top-left, smaller)
local discord = Instance.new("TextButton", top)
discord.Name = "Discord"
discord.Size = UDim2.new(0, 260, 0, 20)
discord.Position = UDim2.new(0, PADDING/2, 0, 36)
discord.BackgroundTransparency = 1
discord.Font = Enum.Font.Gotham
discord.TextSize = 14
discord.TextColor3 = Color3.fromRGB(230,240,255)
discord.TextXAlignment = Enum.TextXAlignment.Left
discord.Text = "discord.gg/Kzzwxg89"
discord.AutoButtonColor = false
discord.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/Kzzwxg89") end)
    title.Text = "Discord copied!"
    delay(1.2, function() if title then title.Text = "Nicolas's Autojoiner" end end)
end)

-- Minimize (minus) button (top left area)
local minBtn = Instance.new("TextButton", top)
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0, 18)
minBtn.AnchorPoint = Vector2.new(0,0)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(240,240,240)
minBtn.BackgroundColor3 = Color3.fromRGB(34,34,40)
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0,6)

-- Yellow divider under the top bar
local divTop = Instance.new("Frame", main)
divTop.Size = UDim2.new(1, 0, 0, 4)
divTop.Position = UDim2.new(0, 0, 0, 72)
divTop.BackgroundColor3 = Color3.fromRGB(246, 196, 0) -- yellow
divTop.BorderSizePixel = 0

-- LEFT PANEL (features)
local left = Instance.new("Frame", main)
left.Name = "Left"
left.Size = UDim2.new(0, LEFT_W, 1, -76)
left.Position = UDim2.new(0, PADDING, 0, 76 + PADDING/2)
left.BackgroundColor3 = Color3.fromRGB(22,24,28)
left.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", left); leftCorner.CornerRadius = UDim.new(0, 10)

-- vertical yellow divider between left and right content
local sep = Instance.new("Frame", main)
sep.Size = UDim2.new(0, 4, 1, -100)
sep.Position = UDim2.new(0, LEFT_W + (PADDING*1.5), 0, 76 + (PADDING/2))
sep.BackgroundColor3 = Color3.fromRGB(246,196,0)
sep.BorderSizePixel = 0

-- LEFT content title
local leftTitle = Instance.new("TextLabel", left)
leftTitle.Size = UDim2.new(1, -24, 0, 26)
leftTitle.Position = UDim2.new(0, 12, 0, 8)
leftTitle.BackgroundTransparency = 1
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextSize = 16
leftTitle.TextColor3 = Color3.fromRGB(230,230,230)
leftTitle.Text = "Features"

-- AutoJoin row
local autoLbl = Instance.new("TextLabel", left)
autoLbl.Size = UDim2.new(1, -24, 0, 22); autoLbl.Position = UDim2.new(0, 12, 0, 44)
autoLbl.BackgroundTransparency = 1; autoLbl.Font = Enum.Font.Gotham; autoLbl.TextSize = 14
autoLbl.TextColor3 = Color3.fromRGB(210,210,210); autoLbl.Text = "AutoJoin"

local autoToggle = Instance.new("TextButton", left)
autoToggle.Size = UDim2.new(0, 64, 0, 28); autoToggle.Position = UDim2.new(1, -76, 0, 40)
autoToggle.Text = getAttr("NAJ.AutoJoin", false) and "ON" or "OFF"
autoToggle.Font = Enum.Font.GothamBold; autoToggle.TextSize = 14
autoToggle.BackgroundColor3 = getAttr("NAJ.AutoJoin", false) and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
autoToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoToggle.BorderSizePixel = 0
local autoCorner = Instance.new("UICorner", autoToggle); autoCorner.CornerRadius = UDim.new(0,6)

-- Min per sec UI
local minLbl = Instance.new("TextLabel", left)
minLbl.Size = UDim2.new(1, -24, 0, 22); minLbl.Position = UDim2.new(0, 12, 0, 84)
minLbl.BackgroundTransparency = 1; minLbl.Font = Enum.Font.Gotham; minLbl.TextSize = 14
minLbl.TextColor3 = Color3.fromRGB(210,210,210); minLbl.Text = "Min Money / sec"

local minBox = Instance.new("TextBox", left)
minBox.Size = UDim2.new(1, -24, 0, 34); minBox.Position = UDim2.new(0, 12, 0, 110)
minBox.BackgroundColor3 = Color3.fromRGB(34,36,40); minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0)); minBox.Font = Enum.Font.Gotham; minBox.TextSize = 16
local minCorner2 = Instance.new("UICorner", minBox); minCorner2.CornerRadius = UDim.new(0,8)

-- Ignore list inputs
local ignLbl = Instance.new("TextLabel", left)
ignLbl.Size = UDim2.new(1, -24, 0, 22); ignLbl.Position = UDim2.new(0, 12, 0, 158)
ignLbl.BackgroundTransparency = 1; ignLbl.Font = Enum.Font.Gotham; ignLbl.TextSize = 14
ignLbl.TextColor3 = Color3.fromRGB(210,210,210); ignLbl.Text = "Ignore list (comma separated)"

local ignBox = Instance.new("TextBox", left)
ignBox.Size = UDim2.new(1, -24, 0, 34); ignBox.Position = UDim2.new(0, 12, 0, 186)
ignBox.BackgroundColor3 = Color3.fromRGB(34,36,40); ignBox.TextColor3 = Color3.fromRGB(220,220,220)
ignBox.Text = "" ; ignBox.Font = Enum.Font.Gotham; ignBox.TextSize = 14
local ignCorner2 = Instance.new("UICorner", ignBox); ignCorner2.CornerRadius = UDim.new(0,8)

local addIgn = Instance.new("TextButton", left)
addIgn.Size = UDim2.new(0, 96, 0, 32); addIgn.Position = UDim2.new(0, 12, 1, -44)
addIgn.Text = "Add Ignore"; addIgn.Font = Enum.Font.GothamBold; addIgn.TextSize = 14
addIgn.BackgroundColor3 = Color3.fromRGB(70,120,215); addIgn.TextColor3 = Color3.fromRGB(255,255,255); addIgn.BorderSizePixel = 0
local addCorner = Instance.new("UICorner", addIgn); addCorner.CornerRadius = UDim.new(0,8)

local clearIgn = Instance.new("TextButton", left)
clearIgn.Size = UDim2.new(0, 96, 0, 32); clearIgn.Position = UDim2.new(1, -108, 1, -44)
clearIgn.Text = "Clear List"; clearIgn.Font = Enum.Font.GothamBold; clearIgn.TextSize = 14
clearIgn.BackgroundColor3 = Color3.fromRGB(60,60,64); clearIgn.TextColor3 = Color3.fromRGB(255,255,255); clearIgn.BorderSizePixel = 0
local clearCorner = Instance.new("UICorner", clearIgn); clearCorner.CornerRadius = UDim.new(0,8)

-- ignore list scroll
local ignLabel2 = Instance.new("TextLabel", left)
ignLabel2.Size = UDim2.new(1, -24, 0, 18); ignLabel2.Position = UDim2.new(0, 12, 0, 230)
ignLabel2.BackgroundTransparency = 1; ignLabel2.Font = Enum.Font.Gotham; ignLabel2.TextSize = 13
ignLabel2.TextColor3 = Color3.fromRGB(200,200,200); ignLabel2.Text = "Current ignores:"

local ignScroll = Instance.new("ScrollingFrame", left)
ignScroll.Size = UDim2.new(1, -24, 0, 86); ignScroll.Position = UDim2.new(0, 12, 0, 250)
ignScroll.BackgroundTransparency = 1; ignScroll.ScrollBarThickness = 6
local ignLayout = Instance.new("UIListLayout", ignScroll); ignLayout.Padding = UDim.new(0,6); ignLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- RIGHT PANEL (live entries)
local right = Instance.new("Frame", main)
right.Name = "Right"
right.Size = UDim2.new(1, -LEFT_W - (PADDING*3) - 8, 1, -92)
right.Position = UDim2.new(0, LEFT_W + (PADDING*2) + 4, 0, 76 + (PADDING/2))
right.BackgroundTransparency = 1

-- columns header
local headerFrame = Instance.new("Frame", right)
headerFrame.Size = UDim2.new(1, 0, 0, 28)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1

local hName = Instance.new("TextLabel", headerFrame)
hName.Size = UDim2.new(0.6, -8, 1, 0); hName.Position = UDim2.new(0, 8, 0, 0)
hName.BackgroundTransparency = 1; hName.Font = Enum.Font.GothamBold; hName.TextSize = 14
hName.Text = "Brainrot"; hName.TextColor3 = Color3.fromRGB(220,220,220); hName.TextXAlignment = Enum.TextXAlignment.Left

local hMoney = hName:Clone(); hMoney.Parent = headerFrame
hMoney.Size = UDim2.new(0.4, -8, 1, 0); hMoney.Position = UDim2.new(0.6, 8, 0, 0)
hMoney.Text = "Money / sec"; hMoney.TextXAlignment = Enum.TextXAlignment.Right

-- list
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1, 0, 1, -28)
list.Position = UDim2.new(0, 0, 0, 28)
list.BackgroundTransparency = 1; list.ScrollBarThickness = 8; list.CanvasSize = UDim2.new(0,0,0,0)
local listLayout = Instance.new("UIListLayout", list)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0,6)

-- table entries storage
local entries = {}
local function refreshCanvas()
    list.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 12)
    ignScroll.CanvasSize = UDim2.new(0,0,0, ignLayout.AbsoluteContentSize.Y + 12)
end

-- add entry
local function addEntry(payload)
    if not payload or not payload.id then return end
    if entries[payload.id] then
        local e = entries[payload.id]
        e.NameLabel.Text = payload.name or e.NameLabel.Text
        e.MoneyLabel.Text = tostring(payload.money or e.MoneyLabel.Text)
        return
    end
    local row = Instance.new("Frame", list)
    row.Size = UDim2.new(1, -8, 0, 44); row.BackgroundColor3 = Color3.fromRGB(22,24,28); row.BorderSizePixel = 0
    local rCorner = Instance.new("UICorner", row); rCorner.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(0.6, -12, 1, 0); nameLbl.Position = UDim2.new(0, 8, 0, 0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 15
    nameLbl.TextColor3 = Color3.fromRGB(235,235,235); nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = tostring(payload.name or "Unknown")

    local moneyLbl = Instance.new("TextLabel", row)
    moneyLbl.Size = UDim2.new(0.4, -12, 1, 0); moneyLbl.Position = UDim2.new(0.6, 8, 0, 0)
    moneyLbl.BackgroundTransparency = 1; moneyLbl.Font = Enum.Font.GothamSemibold; moneyLbl.TextSize = 15
    moneyLbl.TextColor3 = Color3.fromRGB(160,200,255); moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Text = tostring(payload.money or "0")

    -- clickable overlay to request join (safe: fires remote)
    local overlay = Instance.new("TextButton", row)
    overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundTransparency = 1; overlay.Text = ""; overlay.AutoButtonColor = true
    overlay.MouseButton1Click:Connect(function()
        pcall(function() remoteRequest:FireServer({ id = payload.id, name = payload.name, money = payload.money }) end)
    end)

    entries[payload.id] = { Frame = row, NameLabel = nameLbl, MoneyLabel = moneyLbl }
    refreshCanvas()
end

local function removeEntry(id)
    if not id or not entries[id] then return end
    local obj = entries[id].Frame
    if obj and obj.Parent then obj:Destroy() end
    entries[id] = nil
    refreshCanvas()
end

-- remote handlers (server -> client)
remoteAdd.OnClientEvent:Connect(function(payload) addEntry(payload) end)
remoteRemove.OnClientEvent:Connect(function(payload) if payload and payload.id then removeEntry(payload.id) end end)

-- expose local API
_G.NicholasAJ = _G.NicholasAJ or {}
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry

-- ignore list management
local ignoreList = {}
local function rebuildIgnoreUI()
    for _,c in ipairs(ignScroll:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    for i,item in ipairs(ignoreList) do
        local f = Instance.new("Frame", ignScroll); f.Size = UDim2.new(1,0,0,28); f.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1; lbl.Text = tostring(item); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local rem = Instance.new("TextButton", f); rem.Size = UDim2.new(0, 30, 0, 22); rem.Position = UDim2.new(1, -34, 0, 3)
        rem.Text = "X"; rem.Font = Enum.Font.GothamBold; rem.TextSize = 14; rem.BackgroundColor3 = Color3.fromRGB(70,70,70)
        local rc = Instance.new("UICorner", rem); rc.CornerRadius = UDim.new(0,6)
        rem.MouseButton1Click:Connect(function()
            for idx,v in ipairs(ignoreList) do if v == item then table.remove(ignoreList, idx); break end end
            setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
            rebuildIgnoreUI()
        end)
    end
    refreshCanvas()
end

local function loadIgnore()
    local raw = getAttr("NAJ.IgnoreList", "")
    ignoreList = {}
    if raw ~= "" then
        for s in raw:gmatch("[^,]+") do
            local t = s:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then table.insert(ignoreList, t) end
        end
    end
    rebuildIgnoreUI()
end
loadIgnore()

addIgn.MouseButton1Click:Connect(function()
    local toAdd = tostring(ignBox.Text or "")
    if toAdd ~= "" then
        for s in toAdd:gmatch("[^,]+") do
            local t = s:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then table.insert(ignoreList,t) end
        end
        ignBox.Text = ""
        setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
        rebuildIgnoreUI()
    end
end)
clearIgn.MouseButton1Click:Connect(function()
    ignoreList = {}
    setAttr("NAJ.IgnoreList", "")
    rebuildIgnoreUI()
end)

-- AutoToggle
local function applyAuto(v)
    setAttr("NAJ.AutoJoin", v)
    autoToggle.Text = v and "ON" or "OFF"
    autoToggle.BackgroundColor3 = v and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
    statusLabel.Text = v and "Status: AutoJoin ON" or "Status: Idle"
    delay(2, function() statusLabel.Text = "Status: Idle" end)
end
autoToggle.MouseButton1Click:Connect(function()
    applyAuto(not getAttr("NAJ.AutoJoin", false))
end)
applyAuto(getAttr("NAJ.AutoJoin", false))

-- save button (fixed single btn)
local saveBtn = Instance.new("TextButton", left)
saveBtn.Size = UDim2.new(1, -24, 0, 36)
saveBtn.Position = UDim2.new(0, 12, 1, -44)
saveBtn.Text = "Save Settings"
saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 16
saveBtn.BackgroundColor3 = Color3.fromRGB(70,120,220); saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
local saveCorner = Instance.new("UICorner", saveBtn); saveCorner.CornerRadius = UDim.new(0,8)

saveBtn.MouseButton1Click:Connect(function()
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", math.floor(n))
    -- unlimited max (as requested) set to a huge value for safety
    setAttr("NAJ.MaxPerSec", 1e30)
    statusLabel.Text = "Status: Settings saved"
    delay(1.5, function() if statusLabel then statusLabel.Text = "Status: Idle" end end)
end)

-- Title-right status field
local statusLabel = Instance.new("TextLabel", top)
statusLabel.Size = UDim2.new(0, 220, 0, 20)
statusLabel.Position = UDim2.new(1, -246, 0, 48)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(230,230,230)
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Text = "Status: Idle"

-- minimize behavior (collapse to topbar)
local minimized = false
local function minimize()
    if minimized then return end
    minimized = true
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, 72)}):Play()
end
local function restore()
    if not minimized then return end
    minimized = false
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, HEIGHT)}):Play()
end
minBtn.MouseButton1Click:Connect(function() if minimized then restore() else minimize() end end)

-- draggable (top drag area)
local dragging, dragStart, startPos
top.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
top.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inp end end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement and dragStart and startPos then
        local delta = inp.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ensure attributes re-applied on respawn
player.CharacterAdded:Connect(function()
    applyAuto(getAttr("NAJ.AutoJoin", false))
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
end)

-- studio demo entries (only in Studio)
pcall(function()
    if RunService:IsStudio() then
        addEntry({ id = "demo-1", name = "Brainrot Alpha", money = "10,000,000" })
        addEntry({ id = "demo-2", name = "Brainrot Beta", money = "2,500,000" })
    end
end)

-- finished
statusLabel.Text = "Status: Ready"
delay(1.5, function() if statusLabel then statusLabel.Text = "Status: Idle" end end)

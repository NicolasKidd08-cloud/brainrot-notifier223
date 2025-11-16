-- ui.lua
-- Nicolas's AJ — Luamor-priority style UI (SAFE UI ONLY)
-- Place as a LocalScript in StarterPlayer > StarterPlayerScripts OR upload to your GitHub repo

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent names for safe signaling (server may create handlers)
local REMOTE_REQUEST = "NicholasAJ_RequestJoin" -- client -> server when user clicks an entry
local function ensureRemote(name)
    local r = ReplicatedStorage:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then return r end
    r = Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = ReplicatedStorage
    return r
end
local remoteRequest = ensureRemote(REMOTE_REQUEST)

-- Attribute helpers
local function setAttr(k,v) if player:GetAttribute(k) ~= v then player:SetAttribute(k, v) end end
local function getAttr(k,def) local v = player:GetAttribute(k) if v == nil then return def end return v end

-- Defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.IgnoreList", nil) == nil then setAttr("NAJ.IgnoreList", "") end

-- GUI root (use PlayerGui to be safe)
local GUI_NAME = "NicholasAJ_UI_Luamor"
local screenGui = playerGui:FindFirstChild(GUI_NAME)
if screenGui and screenGui:IsA("ScreenGui") then
    screenGui:Destroy()
end
screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Layout constants (Luamor classic-ish)
local WIDTH, HEIGHT = 600, 360
local LEFT_W = 220
local PADDING = 12

-- theme color (blue)
local THEME = Color3.fromRGB(34, 106, 255)

-- main
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.12, 0)
main.AnchorPoint = Vector2.new(0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 12)
main.ClipsDescendants = true

-- rainbow outline
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.LineJoinMode = Enum.LineJoinMode.Round
spawn(function()
    local hue = 0
    while main.Parent do
        hue = (hue + 0.007) % 1
        stroke.Color = Color3.fromHSV(hue, 0.85, 0.95)
        task.wait(0.02)
    end
end)

-- topbar
local top = Instance.new("Frame", main)
top.Name = "Top"
top.Size = UDim2.new(1, 0, 0, 72)
top.Position = UDim2.new(0,0,0,0)
top.BackgroundColor3 = THEME
top.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", top); topCorner.CornerRadius = UDim.new(0, 12)

-- title and discord (top-left area)
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0, 300, 0, 28)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Text = "Nicolas's Autojoiner"

local discord = Instance.new("TextButton", top)
discord.Size = UDim2.new(0, 300, 0, 20)
discord.Position = UDim2.new(0, 14, 0, 36)
discord.BackgroundTransparency = 1
discord.Font = Enum.Font.Gotham
discord.TextSize = 14
discord.TextColor3 = Color3.fromRGB(220,235,255)
discord.TextXAlignment = Enum.TextXAlignment.Left
discord.Text = "discord.gg/Kzzwxg89"
discord.AutoButtonColor = false
discord.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/Kzzwxg89") end)
    local prev = title.Text
    title.Text = "Discord link copied!"
    task.delay(1.2, function() if title then title.Text = prev end end)
end)

-- minimize button (top-right)
local minBtn = Instance.new("TextButton", top)
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 34, 0, 34)
minBtn.Position = UDim2.new(1, -46, 0, 18)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0, 8)

-- top yellow divider
local topDiv = Instance.new("Frame", main)
topDiv.Size = UDim2.new(1, 0, 0, 4)
topDiv.Position = UDim2.new(0, 0, 0, 72)
topDiv.BackgroundColor3 = Color3.fromRGB(246,196,0)
topDiv.BorderSizePixel = 0

-- left panel (features)
local left = Instance.new("Frame", main)
left.Name = "LeftPanel"
left.Size = UDim2.new(0, LEFT_W, 1, -76)
left.Position = UDim2.new(0, PADDING, 0, 76 + PADDING/2)
left.BackgroundColor3 = Color3.fromRGB(22,24,28)
left.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", left); leftCorner.CornerRadius = UDim.new(0, 10)

-- vertical yellow separator between left and right
local vertSep = Instance.new("Frame", main)
vertSep.Size = UDim2.new(0, 4, 1, -100)
vertSep.Position = UDim2.new(0, LEFT_W + (PADDING*1.5), 0, 76 + (PADDING/2))
vertSep.BackgroundColor3 = Color3.fromRGB(246,196,0)
vertSep.BorderSizePixel = 0

-- left title
local leftTitle = Instance.new("TextLabel", left)
leftTitle.Size = UDim2.new(1, -24, 0, 24)
leftTitle.Position = UDim2.new(0, 12, 0, 6)
leftTitle.BackgroundTransparency = 1
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextSize = 16
leftTitle.TextColor3 = Color3.fromRGB(230,230,230)
leftTitle.Text = "AUTOJOIN SETTINGS"

-- AutoJoin toggle row (styled card)
local function makeSettingCard(parent, y, labelText)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -24, 0, 40)
    card.Position = UDim2.new(0, 12, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(28,30,34)
    card.BorderSizePixel = 0
    local cCorner = Instance.new("UICorner", card); cCorner.CornerRadius = UDim.new(0,8)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.6, -8, 1, 0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Text = labelText
    return card, lbl
end

local autoCard, autoLabel = makeSettingCard(left, 46, "Auto Join")
local autoToggle = Instance.new("TextButton", autoCard)
autoToggle.Size = UDim2.new(0, 56, 0, 28)
autoToggle.Position = UDim2.new(1, -68, 0, 6)
autoToggle.Font = Enum.Font.GothamBold
autoToggle.TextSize = 14
autoToggle.Text = getAttr("NAJ.AutoJoin", false) and "ON" or "OFF"
autoToggle.BackgroundColor3 = getAttr("NAJ.AutoJoin", false) and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
local atCorner = Instance.new("UICorner", autoToggle); atCorner.CornerRadius = UDim.new(0,8)
autoToggle.BorderSizePixel = 0

local retryCard, retryLabel = makeSettingCard(left, 96, "Persistent Retry")
local retryToggle = Instance.new("TextButton", retryCard)
retryToggle.Size = UDim2.new(0, 56, 0, 28)
retryToggle.Position = UDim2.new(1, -68, 0, 6)
retryToggle.Font = Enum.Font.GothamBold
retryToggle.TextSize = 14
retryToggle.Text = "OFF"
retryToggle.BackgroundColor3 = Color3.fromRGB(64,64,68)
local rCorner = Instance.new("UICorner", retryToggle); rCorner.CornerRadius = UDim.new(0,8)
retryToggle.BorderSizePixel = 0

-- MONEY FILTER section title
local moneyTitle = Instance.new("TextLabel", left)
moneyTitle.Size = UDim2.new(1, -24, 0, 24)
moneyTitle.Position = UDim2.new(0, 12, 0, 150)
moneyTitle.BackgroundTransparency = 1
moneyTitle.Font = Enum.Font.GothamBold
moneyTitle.TextSize = 14
moneyTitle.TextColor3 = Color3.fromRGB(230,230,230)
moneyTitle.Text = "MONEY FILTER"

-- min M/S card
local minCard = Instance.new("Frame", left)
minCard.Size = UDim2.new(1, -24, 0, 44)
minCard.Position = UDim2.new(0, 12, 0, 182)
minCard.BackgroundColor3 = Color3.fromRGB(28,30,34)
minCard.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minCard); minCorner.CornerRadius = UDim.new(0,8)
local minLabel = Instance.new("TextLabel", minCard)
minLabel.Size = UDim2.new(0.6, -8, 1, 0); minLabel.Position = UDim2.new(0, 8, 0, 0)
minLabel.BackgroundTransparency = 1; minLabel.Font = Enum.Font.Gotham; minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(210,210,210); minLabel.Text = "Min M/S"
local minBox = Instance.new("TextBox", minCard)
minBox.Size = UDim2.new(0.34, -12, 0, 28); minBox.Position = UDim2.new(1, - (0.34*minCard.Size.X.Offset) - 16, 0, 8)
-- position using offsets (safe)
minBox.Position = UDim2.new(1, -86, 0, 8)
minBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
minBox.Font = Enum.Font.Gotham; minBox.TextSize = 14
local minBoxCorner = Instance.new("UICorner", minBox); minBoxCorner.CornerRadius = UDim.new(0,6)

-- IGNORE SETTINGS title
local ignTitle = Instance.new("TextLabel", left)
ignTitle.Size = UDim2.new(1, -24, 0, 24)
ignTitle.Position = UDim2.new(0, 12, 0, 236)
ignTitle.BackgroundTransparency = 1
ignTitle.Font = Enum.Font.GothamBold
ignTitle.TextSize = 14
ignTitle.TextColor3 = Color3.fromRGB(230,230,230)
ignTitle.Text = "IGNORE SETTINGS"

-- enable ignore toggle
local enableCard, enableLabel = makeSettingCard(left, 266, "Enable Ignore List")
local enableToggle = Instance.new("TextButton", enableCard)
enableToggle.Size = UDim2.new(0, 56, 0, 28)
enableToggle.Position = UDim2.new(1, -68, 0, 6)
enableToggle.Font = Enum.Font.GothamBold
enableToggle.TextSize = 14
enableToggle.Text = "OFF"
enableToggle.BackgroundColor3 = Color3.fromRGB(64,64,68)
local enCorner = Instance.new("UICorner", enableToggle); enCorner.CornerRadius = UDim.new(0,8)

-- ignore names box (inside left, but below)
local ignBox = Instance.new("TextBox", left)
ignBox.Size = UDim2.new(1, -24, 0, 34)
ignBox.Position = UDim2.new(0, 12, 1, -86)
ignBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
ignBox.TextColor3 = Color3.fromRGB(220,220,220)
ignBox.PlaceholderText = "ignore1, ignore2, name..."
ignBox.Font = Enum.Font.Gotham; ignBox.TextSize = 13
local ignCorner = Instance.new("UICorner", ignBox); ignCorner.CornerRadius = UDim.new(0,8)

-- Save button removed from visible UI (per request), but we keep persistence when fields lose focus

-- right panel (brainrot list)
local right = Instance.new("Frame", main)
right.Name = "RightPanel"
right.Size = UDim2.new(1, -LEFT_W - (PADDING*3) - 8, 1, -92)
right.Position = UDim2.new(0, LEFT_W + (PADDING*2) + 4, 0, 76 + (PADDING/2))
right.BackgroundTransparency = 1

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

-- list scrolling frame
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1, 0, 1, -28)
list.Position = UDim2.new(0, 0, 0, 28)
list.BackgroundTransparency = 1; list.ScrollBarThickness = 8; list.CanvasSize = UDim2.new(0,0,0,0)
local listLayout = Instance.new("UIListLayout", list); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0,6)

-- store entries
local entries = {}
local function refreshCanvas()
    list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end

local function addEntry(payload)
    if not payload or not payload.id then return end
    if entries[payload.id] then
        local row = entries[payload.id]
        row.NameLabel.Text = payload.name or row.NameLabel.Text
        row.MoneyLabel.Text = tostring(payload.money or row.MoneyLabel.Text)
        return
    end
    local row = Instance.new("Frame", list)
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(26,28,32)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner", row); rowCorner.CornerRadius = UDim.new(0,8)

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

    local overlay = Instance.new("TextButton", row)
    overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundTransparency = 1; overlay.Text = ""
    overlay.AutoButtonColor = true
    overlay.MouseButton1Click:Connect(function()
        -- safe request; server decides what to do
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

-- expose simple local API
_G.NicholasAJ = _G.NicholasAJ or {}
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry

-- load ignore list from attributes
local ignoreList = {}
local function rebuildIgnoreUI()
    for _,c in ipairs(left:GetChildren()) do
        -- do nothing; ignore container is at ignBox
    end
    -- clear current ignore scrolling content
    for _,child in ipairs(left:GetChildren()) do
        -- no-op
    end
    -- build actual UI rows inside a small scrolling area (we store in attribute)
    -- For brevity we show ignore entries in the ignBox placeholder only
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
    -- not building separate scrolling entries to keep layout compact (ignBox shows placeholder)
end
loadIgnore()

-- interactions
autoToggle.MouseButton1Click:Connect(function()
    local cur = getAttr("NAJ.AutoJoin", false)
    cur = not cur
    setAttr("NAJ.AutoJoin", cur)
    autoToggle.Text = cur and "ON" or "OFF"
    autoToggle.BackgroundColor3 = cur and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
end)

retryToggle.MouseButton1Click:Connect(function()
    retryToggle.Text = (retryToggle.Text == "OFF") and "ON" or "OFF"
    retryToggle.BackgroundColor3 = (retryToggle.Text == "ON") and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
end)

enableToggle.MouseButton1Click:Connect(function()
    enableToggle.Text = (enableToggle.Text == "OFF") and "ON" or "OFF"
    enableToggle.BackgroundColor3 = (enableToggle.Text == "ON") and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
end)

minBox.FocusLost:Connect(function()
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", math.floor(n))
    minBox.Text = tostring(math.floor(n))
end)

addIgn.MouseButton1Click:Connect(function()
    local s = tostring(ignBox.Text or "")
    if s ~= "" then
        for part in s:gmatch("[^,]+") do
            local t = part:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then table.insert(ignoreList, t) end
        end
        ignBox.Text = ""
        setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
    end
end)

clearIgn.MouseButton1Click:Connect(function()
    ignoreList = {}
    setAttr("NAJ.IgnoreList", "")
end)

-- minimize/restore logic
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    -- hide everything except top and topDiv when minimized
    for _,v in ipairs(main:GetChildren()) do
        if v ~= top and v ~= topDiv and v ~= stroke then
            v.Visible = not minimized
        end
    end
    -- animate size collapse/restore
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, 72)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, HEIGHT)}):Play()
    end
end)

-- dragging (topbar)
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- restore saved state on character respawn
player.CharacterAdded:Connect(function()
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
    local cur = getAttr("NAJ.AutoJoin", false)
    autoToggle.Text = cur and "ON" or "OFF"
    autoToggle.BackgroundColor3 = cur and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
end)

-- studio demo entries
pcall(function()
    if RunService:IsStudio() then
        addEntry({ id = "d1", name = "Brainrot Alpha", money = "1,100,000" })
        addEntry({ id = "d2", name = "Brainrot Beta", money = "250,000" })
        addEntry({ id = "d3", name = "Brainrot Gamma", money = "90,000" })
    end
end)

-- done

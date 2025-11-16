-- ui.lua
-- Nicolas's AJ — Luarmor-priority style (final)
-- SAFE UI ONLY. LocalScript for StarterPlayerScripts or PlayerGui.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Optional RemoteEvent name for safe requests (server may create handler)
local REMOTE_REQUEST = "NicholasAJ_RequestJoin"
local function ensureRemote(name)
    local r = ReplicatedStorage:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then return r end
    r = Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = ReplicatedStorage
    return r
end
local remoteRequest = ensureRemote(REMOTE_REQUEST)

-- attribute helpers (persist across respawns)
local function setAttr(k,v) if player:GetAttribute(k) ~= v then player:SetAttribute(k, v) end end
local function getAttr(k,d) local v = player:GetAttribute(k) if v == nil then return d end return v end

-- defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.IgnoreList", nil) == nil then setAttr("NAJ.IgnoreList", "") end

-- remove old GUI if present
local GUI_NAME = "NicholasAJ_UI_Final"
local old = playerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- layout constants (tall, less-wide Luarmor-classic)
local WIDTH, HEIGHT = 550, 420   -- slightly taller: fits features nicely
local LEFT_W = 220
local PADDING = 12
local THEME = Color3.fromRGB(34, 106, 255)

-- MAIN FRAME
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.12, 0)
main.AnchorPoint = Vector2.new(0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 14)
main.ClipsDescendants = true

-- shadow frame (soft)
local shadow = Instance.new("Frame", screenGui)
shadow.Name = "Shadow"
shadow.Size = main.Size + UDim2.new(0, 8, 0, 8)
shadow.Position = main.Position + UDim2.new(0, 4, 0, 4)
shadow.AnchorPoint = main.AnchorPoint
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BorderSizePixel = 0
shadow.ZIndex = main.ZIndex - 1
local shadowCorner = Instance.new("UICorner", shadow); shadowCorner.CornerRadius = UDim.new(0, 16)
shadow.BackgroundTransparency = 0.68

-- rainbow animated outline
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.LineJoinMode = Enum.LineJoinMode.Round
spawn(function()
    local h = 0
    while main.Parent do
        h = (h + 0.007) % 1
        stroke.Color = Color3.fromHSV(h, 0.85, 0.95)
        task.wait(0.02)
    end
end)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Name = "Top"
top.Size = UDim2.new(1, 0, 0, 72)
top.Position = UDim2.new(0, 0, 0, 0)
top.BackgroundColor3 = THEME
top.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", top); topCorner.CornerRadius = UDim.new(0,14)

-- Title (top-left)
local title = Instance.new("TextLabel", top)
title.Name = "Title"
title.Size = UDim2.new(0, 320, 0, 28)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Text = "Nicolas's Autojoiner"

-- Discord under title
local discord = Instance.new("TextButton", top)
discord.Name = "Discord"
discord.Size = UDim2.new(0, 320, 0, 18)
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
    title.Text = "Discord copied!"
    task.delay(1.2, function() if title then title.Text = prev end end)
end)

-- MINIMIZE (–) button — TOP-LEFT as requested (works)
local minBtn = Instance.new("TextButton", top)
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 36, 0, 34)
minBtn.Position = UDim2.new(0, 8, 0, 18) -- top-left corner inside topbar
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minBtn.Text = "−"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0, 8)
minBtn.ZIndex = top.ZIndex + 2

-- top divider (yellow)
local topDiv = Instance.new("Frame", main)
topDiv.Name = "TopDivider"
topDiv.Size = UDim2.new(1, 0, 0, 4)
topDiv.Position = UDim2.new(0, 0, 0, 72)
topDiv.BackgroundColor3 = Color3.fromRGB(246, 196, 0)
topDiv.BorderSizePixel = 0

-- LEFT PANEL (Features) — centered "cards" style like Luarmor
local left = Instance.new("Frame", main)
left.Name = "LeftPanel"
left.Size = UDim2.new(0, LEFT_W, 1, -76)
left.Position = UDim2.new(0, PADDING, 0, 76 + PADDING/2)
left.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
left.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", left); leftCorner.CornerRadius = UDim.new(0, 10)

-- vertical yellow separator between left & right (touching both panels)
local vertSep = Instance.new("Frame", main)
vertSep.Name = "VerticalSep"
vertSep.Size = UDim2.new(0, 4, 1, -100)
vertSep.Position = UDim2.new(0, LEFT_W + (PADDING*1.5), 0, 76 + (PADDING/2))
vertSep.BackgroundColor3 = Color3.fromRGB(246,196,0)
vertSep.BorderSizePixel = 0

-- Left Header (AUTOJOIN SETTINGS)
local leftHeader = Instance.new("TextLabel", left)
leftHeader.Size = UDim2.new(1, -24, 0, 24)
leftHeader.Position = UDim2.new(0, 12, 0, 6)
leftHeader.BackgroundTransparency = 1
leftHeader.Font = Enum.Font.GothamBold
leftHeader.TextSize = 14
leftHeader.TextColor3 = Color3.fromRGB(230,230,230)
leftHeader.Text = "AUTOJOIN SETTINGS"

-- helper to build a clean rounded card (Luarmor look)
local function buildCard(parent, y, text)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -24, 0, 44)
    card.Position = UDim2.new(0, 12, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(28,30,34)
    card.BorderSizePixel = 0
    card.ZIndex = parent.ZIndex + 1
    local cCorner = Instance.new("UICorner", card); cCorner.CornerRadius = UDim.new(0, 8)
    -- subtle inner highlight
    local inner = Instance.new("Frame", card)
    inner.Size = UDim2.new(1, 0, 1, 0)
    inner.BackgroundTransparency = 1
    inner.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.64, -8, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Text = text
    return card, lbl
end

-- build feature cards (positions chosen to space evenly)
local autoCard, _ = buildCard(left, 46, "Auto Join")
local autoToggle = Instance.new("TextButton", autoCard)
autoToggle.Size = UDim2.new(0, 56, 0, 28)
autoToggle.Position = UDim2.new(1, -68, 0, 8)
autoToggle.Font = Enum.Font.GothamBold; autoToggle.TextSize = 14
local initialAuto = getAttr("NAJ.AutoJoin", false)
autoToggle.Text = initialAuto and "ON" or "OFF"
autoToggle.BackgroundColor3 = initialAuto and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
local autoCorner = Instance.new("UICorner", autoToggle); autoCorner.CornerRadius = UDim.new(0,8)
autoToggle.BorderSizePixel = 0

local retryCard, _ = buildCard(left, 100, "Persistent Retry")
local retryToggle = Instance.new("TextButton", retryCard)
retryToggle.Size = UDim2.new(0, 56, 0, 28)
retryToggle.Position = UDim2.new(1, -68, 0, 8)
retryToggle.Font = Enum.Font.GothamBold; retryToggle.TextSize = 14
retryToggle.Text = "OFF"
retryToggle.BackgroundColor3 = Color3.fromRGB(64,64,68)
local retryCorner = Instance.new("UICorner", retryToggle); retryCorner.CornerRadius = UDim.new(0,8)

-- MONEY FILTER header & min card
local moneyHeader = Instance.new("TextLabel", left)
moneyHeader.Size = UDim2.new(1, -24, 0, 22)
moneyHeader.Position = UDim2.new(0, 12, 0, 154)
moneyHeader.BackgroundTransparency = 1
moneyHeader.Font = Enum.Font.GothamBold
moneyHeader.TextSize = 13
moneyHeader.TextColor3 = Color3.fromRGB(220,220,220)
moneyHeader.Text = "MONEY FILTER"

local minCard = Instance.new("Frame", left)
minCard.Size = UDim2.new(1, -24, 0, 44)
minCard.Position = UDim2.new(0, 12, 0, 182)
minCard.BackgroundColor3 = Color3.fromRGB(28,30,34)
minCard.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minCard); minCorner.CornerRadius = UDim.new(0,8)
local minLabel = Instance.new("TextLabel", minCard)
minLabel.Size = UDim2.new(0.6, -8, 1, 0)
minLabel.Position = UDim2.new(0, 8, 0, 0)
minLabel.BackgroundTransparency = 1
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(210,210,210)
minLabel.Text = "Min M/S"
local minBox = Instance.new("TextBox", minCard)
minBox.Size = UDim2.new(0.34, -12, 0, 28)
minBox.Position = UDim2.new(1, -86, 0, 8)
minBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
minBox.Font = Enum.Font.Gotham; minBox.TextSize = 14
local minBoxCorner = Instance.new("UICorner", minBox); minBoxCorner.CornerRadius = UDim.new(0,6)

-- IGNORE SETTINGS header & cards
local ignHeader = Instance.new("TextLabel", left)
ignHeader.Size = UDim2.new(1, -24, 0, 22)
ignHeader.Position = UDim2.new(0, 12, 0, 236)
ignHeader.BackgroundTransparency = 1
ignHeader.Font = Enum.Font.GothamBold
ignHeader.TextSize = 13
ignHeader.TextColor3 = Color3.fromRGB(220,220,220)
ignHeader.Text = "IGNORE SETTINGS"

local enableCard, _ = buildCard(left, 266, "Enable Ignore List")
local enableToggle = Instance.new("TextButton", enableCard)
enableToggle.Size = UDim2.new(0,56,0,28)
enableToggle.Position = UDim2.new(1, -68, 0, 8)
enableToggle.Font = Enum.Font.GothamBold; enableToggle.TextSize = 14
enableToggle.Text = "OFF"; enableToggle.BackgroundColor3 = Color3.fromRGB(64,64,68)
local enableCorner = Instance.new("UICorner", enableToggle); enableCorner.CornerRadius = UDim.new(0,8)

local ignBox = Instance.new("TextBox", left)
ignBox.Size = UDim2.new(1, -24, 0, 34)
ignBox.Position = UDim2.new(0, 12, 1, -86)
ignBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
ignBox.TextColor3 = Color3.fromRGB(220,220,220)
ignBox.PlaceholderText = "name1, name2, ..."
ignBox.Font = Enum.Font.Gotham; ignBox.TextSize = 13
local ignCorner = Instance.new("UICorner", ignBox); ignCorner.CornerRadius = UDim.new(0,8)

-- RIGHT PANEL (Brainrot list) — same bottom height and connected visually
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

-- list frame
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1, 0, 1, -28)
list.Position = UDim2.new(0, 0, 0, 28)
list.BackgroundTransparency = 1; list.ScrollBarThickness = 8; list.CanvasSize = UDim2.new(0,0,0,0)
local listLayout = Instance.new("UIListLayout", list); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0,6)

-- store entries table
local entries = {}
local function refreshCanvas()
    list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end

local function addEntry(payload)
    if not payload or not payload.id then return end
    if entries[payload.id] then
        local e = entries[payload.id]
        e.NameLabel.Text = payload.name or e.NameLabel.Text
        e.MoneyLabel.Text = tostring(payload.money or e.MoneyLabel.Text)
        return
    end
    local row = Instance.new("Frame", list)
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(26,28,32)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner", row); rowCorner.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(0.6, -12, 1, 0); nameLbl.Position = UDim2.new(0,8,0,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 15
    nameLbl.TextColor3 = Color3.fromRGB(235,235,235); nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = tostring(payload.name or "Unknown")

    local moneyLbl = Instance.new("TextLabel", row)
    moneyLbl.Size = UDim2.new(0.4, -12, 1, 0); moneyLbl.Position = UDim2.new(0.6,8,0,0)
    moneyLbl.BackgroundTransparency = 1; moneyLbl.Font = Enum.Font.GothamSemibold; moneyLbl.TextSize = 15
    moneyLbl.TextColor3 = Color3.fromRGB(160,200,255); moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Text = tostring(payload.money or "0")

    -- thin row separator at bottom
    local sep = Instance.new("Frame", row)
    sep.Size = UDim2.new(1, -16, 0, 1)
    sep.Position = UDim2.new(0, 8, 1, -6)
    sep.BackgroundColor3 = Color3.fromRGB(42,42,48)
    sep.BorderSizePixel = 0

    local overlay = Instance.new("TextButton", row)
    overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundTransparency = 1; overlay.Text = ""
    overlay.AutoButtonColor = true
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

-- expose API
_G.NicholasAJ = _G.NicholasAJ or {}
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry

-- load ignore list
local ignoreList = {}
local function loadIgnore()
    ignoreList = {}
    local raw = getAttr("NAJ.IgnoreList", "")
    if raw ~= "" then
        for s in raw:gmatch("[^,]+") do
            local t = s:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then table.insert(ignoreList, t) end
        end
    end
end
loadIgnore()

-- interactions & persistence
autoToggle.MouseButton1Click:Connect(function()
    local cur = not getAttr("NAJ.AutoJoin", false)
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

minBox.FocusLost:Connect(function(enter)
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", math.floor(n))
    minBox.Text = tostring(math.floor(n))
end)

ignBox.FocusLost:Connect(function()
    local s = tostring(ignBox.Text or "")
    local tlist = {}
    if s ~= "" then
        for part in s:gmatch("[^,]+") do
            local t = part:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then table.insert(tlist, t) end
        end
    end
    ignoreList = tlist
    setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
end)

-- MINIMIZE / RESTORE logic (top-left button)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in ipairs(main:GetChildren()) do
        if v ~= top and v ~= topDiv and v ~= stroke then
            v.Visible = not minimized
        end
    end
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, 72)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = main.Size + UDim2.new(0,8,0,8), Position = main.Position + UDim2.new(0,4,0,4)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, HEIGHT)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = main.Size + UDim2.new(0,8,0,8), Position = main.Position + UDim2.new(0,4,0,4)}):Play()
    end
end)

-- DRAGGING (topbar), works while minimized
local dragging, dragStart, startPos, dragInput
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
        shadow.Position = main.Position + UDim2.new(0,4,0,4)
    end
end)

-- restore state on respawn
player.CharacterAdded:Connect(function()
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
    local cur = getAttr("NAJ.AutoJoin", false)
    autoToggle.Text = cur and "ON" or "OFF"
    autoToggle.BackgroundColor3 = cur and Color3.fromRGB(80,180,80) or Color3.fromRGB(64,64,68)
end)

-- studio demo entries (visible in Studio)
pcall(function()
    if RunService:IsStudio() then
        addEntry({ id = "demo-1", name = "Brainrot Alpha", money = "10,000,000" })
        addEntry({ id = "demo-2", name = "Brainrot Beta", money = "2,500,000" })
    end
end)

-- done



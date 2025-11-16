-- ui.lua - Final Nicolas's AJ (UI-only, safe)
-- Place as LocalScript in StarterPlayer > StarterPlayerScripts or paste into your repo.

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Optional remote names (server may create these)
local REMOTE_REQUEST = "NicholasAJ_RequestJoin"   -- client -> server when clicking a row
local REMOTE_PUSH = "NicholasAJ_PushEntry"        -- server -> client to push an entry (optional)

-- Ensure remote(s) exist client-side (server may create their own)
local function ensureRemote(name)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if obj and obj:IsA("RemoteEvent") then return obj end
    -- create a local RemoteEvent so client code doesn't error if server didn't set it
    local re = Instance.new("RemoteEvent")
    re.Name = name
    re.Parent = ReplicatedStorage
    return re
end
local remoteRequest = ensureRemote(REMOTE_REQUEST)
local remotePush = ensureRemote(REMOTE_PUSH)

-- Attribute helpers (persist across respawns)
local function setAttr(k,v) if player:GetAttribute(k) ~= v then player:SetAttribute(k,v) end end
local function getAttr(k,def) local v = player:GetAttribute(k) if v==nil then return def end return v end

-- Defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.IgnoreList", nil) == nil then setAttr("NAJ.IgnoreList", "") end

-- Clear any previous GUI we created
local GUI_NAME = "NicholasAJ_UI_Final_v2"
local existing = playerGui:FindFirstChild(GUI_NAME)
if existing then existing:Destroy() end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Layout constants (bigger UI, taller, left features smaller, right list bigger)
local WIDTH, HEIGHT = 680, 460          -- overall bigger per your request
local LEFT_W = 220
local TOP_H = 64                         -- slightly smaller topbar
local PADDING = 14
local THEME = Color3.fromRGB(34,106,255)

-- Main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.12, 0)
main.AnchorPoint = Vector2.new(0.5,0)
main.BackgroundColor3 = Color3.fromRGB(16,18,24)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0,14)
main.ClipsDescendants = true

-- Soft shadow frame (behind)
local shadow = Instance.new("Frame", screenGui)
shadow.Name = "Shadow"
shadow.Size = main.Size + UDim2.new(0,8,0,8)
shadow.Position = main.Position + UDim2.new(0,4,0,4)
shadow.AnchorPoint = main.AnchorPoint
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BorderSizePixel = 0
shadow.ZIndex = main.ZIndex - 1
local shadowCorner = Instance.new("UICorner", shadow); shadowCorner.CornerRadius = UDim.new(0,16)
shadow.BackgroundTransparency = 0.7

-- Animated rainbow outline
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.LineJoinMode = Enum.LineJoinMode.Round
spawn(function()
    local h = 0
    while main.Parent do
        h = (h + 0.006) % 1
        stroke.Color = Color3.fromHSV(h, 0.85, 0.95)
        task.wait(0.02)
    end
end)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Name = "Top"
top.Size = UDim2.new(1,0,0,TOP_H)
top.Position = UDim2.new(0,0,0,0)
top.BackgroundColor3 = THEME
top.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", top); topCorner.CornerRadius = UDim.new(0,14)

-- Title and big Discord (Discord slightly bigger)
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0, 380, 0, 26)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Text = "Nicolas's Autojoiner"

local discord = Instance.new("TextLabel", top)
discord.Name = "Discord"
discord.Size = UDim2.new(0, 380, 0, 20)
discord.Position = UDim2.new(0, 14, 0, 30)
discord.BackgroundTransparency = 1
discord.Font = Enum.Font.GothamSemibold
discord.TextSize = 15
discord.TextColor3 = Color3.fromRGB(220,235,255)
discord.Text = "discord.gg/Kzzwxg89"
discord.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE (small red pill) - TOP-LEFT as requested earlier
local minBtn = Instance.new("TextButton", top)
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.Position = UDim2.new(0, 8, 0, 18)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
minBtn.Text = "−"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0,6)
minBtn.ZIndex = top.ZIndex + 2

-- top divider (yellow)
local topDiv = Instance.new("Frame", main)
topDiv.Size = UDim2.new(1, 0, 0, 4)
topDiv.Position = UDim2.new(0, 0, 0, TOP_H)
topDiv.BackgroundColor3 = Color3.fromRGB(246,196,0)
topDiv.BorderSizePixel = 0

-- LEFT FEATURES PANEL
local left = Instance.new("Frame", main)
left.Name = "Left"
left.Size = UDim2.new(0, LEFT_W, 1, -TOP_H - (PADDING*1.5))
left.Position = UDim2.new(0, PADDING, 0, TOP_H + (PADDING/2))
left.BackgroundColor3 = Color3.fromRGB(20,22,26)
left.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", left); leftCorner.CornerRadius = UDim.new(0,10)

-- vertical separator (yellow) between left and right (touches both)
local vertSep = Instance.new("Frame", main)
vertSep.Size = UDim2.new(0, 4, 1, -TOP_H - (PADDING*1.5))
vertSep.Position = UDim2.new(0, LEFT_W + (PADDING*1.5), 0, TOP_H + (PADDING/2))
vertSep.BackgroundColor3 = Color3.fromRGB(246,196,0)
vertSep.BorderSizePixel = 0

-- Features header text
local leftHeader = Instance.new("TextLabel", left)
leftHeader.Size = UDim2.new(1, -24, 0, 22)
leftHeader.Position = UDim2.new(0, 12, 0, 8)
leftHeader.BackgroundTransparency = 1
leftHeader.Font = Enum.Font.GothamBold
leftHeader.TextSize = 14
leftHeader.TextColor3 = Color3.fromRGB(230,230,230)
leftHeader.Text = "AUTOJOIN SETTINGS"

-- helper to build smaller clean card (Luarmor-like)
local function smallCard(parent, y, labelText)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -24, 0, 40)
    card.Position = UDim2.new(0, 12, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(28,30,34)
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card); cardCorner.CornerRadius = UDim.new(0,8)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.62, -8, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Text = labelText
    return card, lbl
end

-- Auto-Join toggle (single, small and compact)
local autoCard, autoLabel = smallCard(left, 46, "Auto Join")
local autoToggle = Instance.new("TextButton", autoCard)
autoToggle.Size = UDim2.new(0, 48, 0, 28)
autoToggle.Position = UDim2.new(1, -64, 0, 6)
autoToggle.Font = Enum.Font.GothamBold; autoToggle.TextSize = 13
local curAuto = getAttr("NAJ.AutoJoin", false)
autoToggle.Text = "" -- no text, visual color defines
autoToggle.BackgroundColor3 = curAuto and THEME or Color3.fromRGB(16,16,20)
local autoToggleCorner = Instance.new("UICorner", autoToggle); autoToggleCorner.CornerRadius = UDim.new(0,6)
local autoToggleIndicator = Instance.new("Frame", autoToggle)
autoToggleIndicator.AnchorPoint = Vector2.new(0.5,0.5)
autoToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
autoToggleIndicator.Position = UDim2.new(0.5, 0.5, 0.5, 0)
autoToggleIndicator.BackgroundColor3 = curAuto and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80)
local autoIndCorner = Instance.new("UICorner", autoToggleIndicator); autoIndCorner.CornerRadius = UDim.new(0,10)

-- Money filter removed except Min M/S
local moneyHeader = Instance.new("TextLabel", left)
moneyHeader.Size = UDim2.new(1, -24, 0, 20)
moneyHeader.Position = UDim2.new(0, 12, 0, 96)
moneyHeader.BackgroundTransparency = 1
moneyHeader.Font = Enum.Font.GothamBold
moneyHeader.TextSize = 13
moneyHeader.TextColor3 = Color3.fromRGB(220,220,220)
moneyHeader.Text = "MONEY FILTER"

local minCard = Instance.new("Frame", left)
minCard.Size = UDim2.new(1, -24, 0, 40)
minCard.Position = UDim2.new(0, 12, 0, 122)
minCard.BackgroundColor3 = Color3.fromRGB(28,30,34)
minCard.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minCard); minCorner.CornerRadius = UDim.new(0,8)
local minLabel = Instance.new("TextLabel", minCard)
minLabel.Size = UDim2.new(0.58, -8, 1, 0)
minLabel.Position = UDim2.new(0, 8, 0, 0)
minLabel.BackgroundTransparency = 1; minLabel.Font = Enum.Font.Gotham; minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(210,210,210); minLabel.Text = "Min M/S"
local minBox = Instance.new("TextBox", minCard)
minBox.Size = UDim2.new(0.36, -12, 0, 26)
minBox.Position = UDim2.new(1, -84, 0, 7)
minBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
minBox.Font = Enum.Font.Gotham; minBox.TextSize = 14
local minBoxCorner = Instance.new("UICorner", minBox); minBoxCorner.CornerRadius = UDim.new(0,6)

-- IGNORE SETTINGS header
local ignHeader = Instance.new("TextLabel", left)
ignHeader.Size = UDim2.new(1, -24, 0, 20)
ignHeader.Position = UDim2.new(0, 12, 0, 174)
ignHeader.BackgroundTransparency = 1
ignHeader.Font = Enum.Font.GothamBold
ignHeader.TextSize = 13
ignHeader.TextColor3 = Color3.fromRGB(220,220,220)
ignHeader.Text = "IGNORE SETTINGS"

-- Big selectable list of brainrots (scrolling) - you can populate via API
local brainListFrame = Instance.new("ScrollingFrame", left)
brainListFrame.Size = UDim2.new(1, -24, 0, 150)
brainListFrame.Position = UDim2.new(0, 12, 0, 200)
brainListFrame.BackgroundTransparency = 1
brainListFrame.ScrollBarThickness = 8
local brainListLayout = Instance.new("UIListLayout", brainListFrame)
brainListLayout.SortOrder = Enum.SortOrder.LayoutOrder
brainListLayout.Padding = UDim.new(0,6)

-- container for ignored names display is handled via selection (entries)
local ignoredSet = {} -- track ignored names (set)
local function loadIgnoredFromAttr()
    ignoredSet = {}
    local raw = getAttr("NAJ.IgnoreList", "")
    if raw ~= "" then
        for s in raw:gmatch("[^,]+") do
            local t = s:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then ignoredSet[t] = true end
        end
    end
end
loadIgnoredFromAttr()

-- function to rebuild brainListFrame entries (for ignore list)
local brainEntries = {}
local function rebuildBrainListDisplay(names)
    -- names = array of strings
    for _,c in ipairs(brainListFrame:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    brainEntries = {}
    for i,name in ipairs(names) do
        local row = Instance.new("Frame", brainListFrame)
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.72, 0, 1, 0)
        lbl.Position = UDim2.new(0, 2, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Color3.fromRGB(230,230,230)
        lbl.Text = name
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", row)
        toggle.Size = UDim2.new(0.26, -4, 0, 20)
        toggle.Position = UDim2.new(1, - (0.26 * 200) - 6, 0, 4) -- rough placement
        toggle.AnchorPoint = Vector2.new(1,0)
        toggle.BackgroundColor3 = ignoredSet[name] and THEME or Color3.fromRGB(30,30,34)
        toggle.Text = ignoredSet[name] and "IGNORED" or "IGNORE"
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 12
        toggle.TextColor3 = Color3.fromRGB(255,255,255)
        local tCorner = Instance.new("UICorner", toggle); tCorner.CornerRadius = UDim.new(0,6)
        toggle.BorderSizePixel = 0

        toggle.MouseButton1Click:Connect(function()
            if ignoredSet[name] then
                ignoredSet[name] = nil
                toggle.BackgroundColor3 = Color3.fromRGB(30,30,34)
                toggle.Text = "IGNORE"
            else
                ignoredSet[name] = true
                toggle.BackgroundColor3 = THEME
                toggle.Text = "IGNORED"
            end
            -- persist to attribute
            local parts = {}
            for k,_ in pairs(ignoredSet) do table.insert(parts, k) end
            setAttr("NAJ.IgnoreList", table.concat(parts, ","))
        end)

        brainEntries[name] = { Row = row, Label = lbl, Toggle = toggle }
    end
    brainListFrame.CanvasSize = UDim2.new(0,0,0, brainListLayout.AbsoluteContentSize.Y + 8)
end

-- RIGHT PANEL (bigger brainrot list)
local right = Instance.new("Frame", main)
right.Name = "Right"
right.Size = UDim2.new(1, -LEFT_W - (PADDING*3) - 8, 1, -TOP_H - (PADDING*2))
right.Position = UDim2.new(0, LEFT_W + (PADDING*2) + 4, 0, TOP_H + (PADDING/1.25))
right.BackgroundTransparency = 1

-- header row in right panel
local headerFrame = Instance.new("Frame", right)
headerFrame.Size = UDim2.new(1, 0, 0, 30)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1
local hName = Instance.new("TextLabel", headerFrame)
hName.Size = UDim2.new(0.62, -8, 1, 0); hName.Position = UDim2.new(0, 8, 0, 0)
hName.BackgroundTransparency = 1; hName.Font = Enum.Font.GothamBold; hName.TextSize = 14
hName.Text = "Brainrot"; hName.TextColor3 = Color3.fromRGB(220,220,220); hName.TextXAlignment = Enum.TextXAlignment.Left
local hMoney = hName:Clone(); hMoney.Parent = headerFrame
hMoney.Size = UDim2.new(0.38, -8, 1, 0); hMoney.Position = UDim2.new(0.62, 8, 0, 0)
hMoney.Text = "Money / sec"; hMoney.TextXAlignment = Enum.TextXAlignment.Right

-- scrolling frame for right list
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1, 0, 1, -30)
list.Position = UDim2.new(0, 0, 0, 30)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 10
local listLayout = Instance.new("UIListLayout", list)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,8)

-- right side entries store
local entries = {}
local function refreshCanvas()
    list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end

-- Add / Update a row in the brainrot list
local function addEntry(payload)
    -- payload = { id=string, name=string, money=number/string }
    if not payload or not payload.id then return end
    if entries[payload.id] then
        local row = entries[payload.id]
        row.NameLabel.Text = payload.name or row.NameLabel.Text
        row.MoneyLabel.Text = tostring(payload.money or row.MoneyLabel.Text)
        return
    end
    local row = Instance.new("Frame", list)
    row.Size = UDim2.new(1, -8, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(26,28,32)
    row.BorderSizePixel = 0
    local rc = Instance.new("UICorner", row); rc.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(0.62, -12, 1, 0); nameLbl.Position = UDim2.new(0, 8, 0, 0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 15
    nameLbl.TextColor3 = Color3.fromRGB(235,235,235); nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = tostring(payload.name or "Unknown")

    local moneyLbl = Instance.new("TextLabel", row)
    moneyLbl.Size = UDim2.new(0.38, -12, 1, 0); moneyLbl.Position = UDim2.new(0.62, 8, 0, 0)
    moneyLbl.BackgroundTransparency = 1; moneyLbl.Font = Enum.Font.GothamSemibold; moneyLbl.TextSize = 15
    moneyLbl.TextColor3 = Color3.fromRGB(160,200,255); moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Text = tostring(payload.money or "0")

    -- thin row separator
    local sep = Instance.new("Frame", row)
    sep.Size = UDim2.new(1, -16, 0, 1)
    sep.Position = UDim2.new(0, 8, 1, -8)
    sep.BackgroundColor3 = Color3.fromRGB(42,42,48)
    sep.BorderSizePixel = 0

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        -- safe client -> server intent; server decides what to do
        pcall(function()
            remoteRequest:FireServer({ id = payload.id, name = payload.name, money = payload.money })
        end)
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

-- Expose API for populating brainrot names on the left ignore list
_G.NicholasAJ = _G.NicholasAJ or {}
_G.NicholasAJ.SetBrainrotList = function(names)
    -- names = array of strings
    rebuildBrainListDisplay(names or {})
end
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry
_G.NicholasAJ.GetIgnored = function()
    local t = {}
    for k,_ in pairs(ignoredSet) do table.insert(t, k) end
    return t
end

-- Allow server to push entries via remotePush: expects payload { id,name,money }
remotePush.OnClientEvent:Connect(function(payload)
    if payload and payload.id then addEntry(payload) end
end)

-- Small studio demo brainrot names and right list sample
pcall(function()
    if RunService:IsStudio() then
        local sampleNames = {"Secret Brainrot A","Secret Brainrot B","Secret Brainrot C","Ultra Rare Brainrot"}
        _G.NicholasAJ.SetBrainrotList(sampleNames)
        addEntry({ id = "s1", name = "Secret Brainrot A", money = "12,000,000" })
        addEntry({ id = "s2", name = "Secret Brainrot B", money = "3,200,000" })
        addEntry({ id = "s3", name = "Ultra Rare Brainrot", money = "50,000,000" })
    end
end)

-- Interactions & persistence
autoToggle.MouseButton1Click:Connect(function()
    local cur = not getAttr("NAJ.AutoJoin", false)
    setAttr("NAJ.AutoJoin", cur)
    autoToggle.BackgroundColor3 = cur and THEME or Color3.fromRGB(16,16,20)
    autoToggleIndicator.BackgroundColor3 = cur and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80)
end)

minBox.FocusLost:Connect(function()
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", math.floor(n))
    minBox.Text = tostring(math.floor(n))
end)

-- minimize behavior: collapse to topbar only (90% collapsed)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in ipairs(main:GetChildren()) do
        if v ~= top and v ~= topDiv and v ~= stroke then
            v.Visible = not minimized
        end
    end
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, TOP_H + 6)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Size = UDim2.new(0, WIDTH + 8, 0, TOP_H + 8), Position = main.Position + UDim2.new(0,4,0,4)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, HEIGHT)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Size = main.Size + UDim2.new(0,8,0,8), Position = main.Position + UDim2.new(0,4,0,4)}):Play()
    end
end)

-- Dragging: top bar draggable, works while minimized
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

-- Restore attributes on respawn
player.CharacterAdded:Connect(function()
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
    local cur = getAttr("NAJ.AutoJoin", false)
    autoToggle.BackgroundColor3 = cur and THEME or Color3.fromRGB(16,16,20)
    autoToggleIndicator.BackgroundColor3 = cur and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80)
    loadIgnoredFromAttr()
end)

-- Done
print("[NicholasAJ] UI ready")


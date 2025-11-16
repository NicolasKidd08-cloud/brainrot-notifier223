-- Nicholas's AJ — Full UI (LocalScript)
-- Place in StarterPlayer -> StarterPlayerScripts
-- Safe: UI only. Client signals join intent via RemoteEvent; server must implement teleport/validation.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent names (server can create these if desired)
local REMOTE_ADD = "NicholasAJ_AddEntry"      -- server -> client to add an entry {id,name,money}
local REMOTE_REMOVE = "NicholasAJ_RemoveEntry" -- server -> client to remove an entry {id}
local REMOTE_REQUEST = "NicholasAJ_RequestJoin" -- client -> server to request join {id, name, money}

-- Ensure RemoteEvents exist (server may also create them)
local function getOrCreateRemote(name)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if obj and obj:IsA("RemoteEvent") then return obj end
    obj = Instance.new("RemoteEvent")
    obj.Name = name
    obj.Parent = ReplicatedStorage
    return obj
end
local remoteAdd = getOrCreateRemote(REMOTE_ADD)
local remoteRemove = getOrCreateRemote(REMOTE_REMOVE)
local remoteRequest = getOrCreateRemote(REMOTE_REQUEST)

-- Utilities for attributes (persistent across respawns)
local function setAttr(k, v) if player:GetAttribute(k) ~= v then player:SetAttribute(k, v) end end
local function getAttr(k, fallback) local v = player:GetAttribute(k) if v == nil then return fallback end return v end

-- Defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.ThemeR", nil) == nil then
    local d = Color3.fromRGB(34, 106, 255)
    setAttr("NAJ.ThemeR", d.R); setAttr("NAJ.ThemeG", d.G); setAttr("NAJ.ThemeB", d.B)
end

-- Create ScreenGui (reuse if exists)
local GUI_NAME = "NicholasAJ_GUI_v1"
local screenGui = playerGui:FindFirstChild(GUI_NAME)
if screenGui and screenGui:IsA("ScreenGui") then
    -- reuse
else
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = GUI_NAME
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false -- persist after death
    screenGui.IgnoreGuiInset = true
end

-- Clear previous children to avoid duplicates on script re-run
for _,c in ipairs(screenGui:GetChildren()) do c:Destroy() end

-- Theme
local function currentTheme() return Color3.new(getAttr("NAJ.ThemeR", 34), getAttr("NAJ.ThemeG", 106), getAttr("NAJ.ThemeB", 255)) end

-- ====== MAIN PANEL ======
local MAIN_W, MAIN_H = 880, 420
local main = Instance.new("Frame"); main.Name = "Main"; main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
main.Position = UDim2.new(0.5, -MAIN_W/2, 0.08, 0)
main.AnchorPoint = Vector2.new(0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 14)
main.ClipsDescendants = true

-- Animated rainbow outline via UIStroke (tweening its Color)
local outline = Instance.new("UIStroke", main)
outline.Thickness = 2
outline.Transparency = 0
outline.LineJoinMode = Enum.LineJoinMode.Round

-- animate rainbow (loop)
spawn(function()
    local hue = 0
    while main.Parent do
        hue = (hue + 0.008) % 1
        local col = Color3.fromHSV(hue, 0.85, 0.95)
        outline.Color = col
        task.wait(0.02)
    end
end)

-- Topbar (draggable)
local topbar = Instance.new("Frame", main)
topbar.Name = "Topbar"; topbar.Size = UDim2.new(1, 0, 0, 70); topbar.Position = UDim2.new(0,0,0,0)
topbar.BackgroundTransparency = 1
local topCorner = Instance.new("UICorner", topbar); topCorner.CornerRadius = UDim.new(0, 14)

-- Left: small title (Nicolas's Autojoiner) and minimize button
local title = Instance.new("TextLabel", topbar)
title.Name = "Title"; title.Size = UDim2.new(0, 280, 1, 0); title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold; title.TextSize = 20
title.TextColor3 = Color3.fromRGB(230,230,230); title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Nicolas's Autojoiner"

local minimizeBtn = Instance.new("TextButton", topbar)
minimizeBtn.Name = "Minimize"; minimizeBtn.Size = UDim2.new(0, 34, 0, 34)
minimizeBtn.Position = UDim2.new(0, 300, 0, 18)
minimizeBtn.AnchorPoint = Vector2.new(0,0)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold; minimizeBtn.TextSize = 24
minimizeBtn.TextColor3 = Color3.fromRGB(220,220,220)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(38, 44, 56)
minimizeBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minimizeBtn); minCorner.CornerRadius = UDim.new(0,8)

-- Center: Big Discord link (centered)
local discord = Instance.new("TextButton", topbar)
discord.Name = "Discord"
discord.Size = UDim2.new(0, 520, 0, 46)
discord.Position = UDim2.new(0.5, -260, 0.5, -23)
discord.AnchorPoint = Vector2.new(0.5, 0.5)
discord.Text = "JOIN DISCORD • discord.gg/Kzzwxg89"
discord.Font = Enum.Font.GothamBold; discord.TextSize = 20
discord.TextColor3 = Color3.fromRGB(150,210,255)
discord.BackgroundTransparency = 1
discord.TextWrapped = true

discord.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/Kzzwxg89") end)
    -- small visual feedback
    local prev = title.Text
    title.Text = "Discord link copied!"
    delay(1.5, function() if title then title.Text = prev end end)
end)

-- Right: controls area (AutoJoin status)
local rightBox = Instance.new("Frame", topbar)
rightBox.Size = UDim2.new(0, 230, 1, 0); rightBox.Position = UDim2.new(1, -246, 0, 0)
rightBox.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel", rightBox)
statusLabel.Size = UDim2.new(1, -12, 0, 26); statusLabel.Position = UDim2.new(0, 6, 0, 12)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200,200,200); statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Text = "Status: Idle"

-- ===== LEFT PANEL (features) =====
local leftW = 260
local leftPanel = Instance.new("Frame", main)
leftPanel.Name = "LeftPanel"; leftPanel.Size = UDim2.new(0, leftW, 1, -70); leftPanel.Position = UDim2.new(0, 0, 0, 70)
leftPanel.BackgroundColor3 = Color3.fromRGB(20,22,26); leftPanel.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", leftPanel); leftCorner.CornerRadius = UDim.new(0,12)

local leftTitle = Instance.new("TextLabel", leftPanel)
leftTitle.Size = UDim2.new(1, -20, 0, 28); leftTitle.Position = UDim2.new(0, 10, 0, 12)
leftTitle.BackgroundTransparency = 1; leftTitle.Font = Enum.Font.GothamBold; leftTitle.TextSize = 16
leftTitle.TextColor3 = Color3.fromRGB(230,230,230); leftTitle.Text = "Features"

-- AutoJoin toggle
local autoLabel = Instance.new("TextLabel", leftPanel)
autoLabel.Size = UDim2.new(1, -20, 0, 22); autoLabel.Position = UDim2.new(0, 10, 0, 52)
autoLabel.BackgroundTransparency = 1; autoLabel.Font = Enum.Font.Gotham; autoLabel.TextSize = 14
autoLabel.TextColor3 = Color3.fromRGB(200,200,200); autoLabel.Text = "AutoJoin"

local autoToggle = Instance.new("TextButton", leftPanel)
autoToggle.Size = UDim2.new(0, 52, 0, 28); autoToggle.Position = UDim2.new(1, -68, 0, 50)
autoToggle.AnchorPoint = Vector2.new(0,0)
autoToggle.Text = getAttr("NAJ.AutoJoin", false) and "ON" or "OFF"
autoToggle.Font = Enum.Font.GothamBold; autoToggle.TextSize = 14
autoToggle.BackgroundColor3 = getAttr("NAJ.AutoJoin", false) and Color3.fromRGB(80,170,80) or Color3.fromRGB(60,60,64)
local autoCorner2 = Instance.new("UICorner", autoToggle); autoCorner2.CornerRadius = UDim.new(0,6)

-- Min per sec input
local minLabel = Instance.new("TextLabel", leftPanel)
minLabel.Size = UDim2.new(1, -20, 0, 22); minLabel.Position = UDim2.new(0, 10, 0, 92)
minLabel.BackgroundTransparency = 1; minLabel.Font = Enum.Font.Gotham; minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(200,200,200); minLabel.Text = "Min Money / sec"

local minBox = Instance.new("TextBox", leftPanel)
minBox.Size = UDim2.new(1, -20, 0, 34); minBox.Position = UDim2.new(0, 10, 0, 118)
minBox.BackgroundColor3 = Color3.fromRGB(40,44,52); minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0)); minBox.Font = Enum.Font.Gotham; minBox.TextSize = 16
local minCorner2 = Instance.new("UICorner", minBox); minCorner2.CornerRadius = UDim.new(0,8)

-- Ignore list input + add
local ignLabel = Instance.new("TextLabel", leftPanel)
ignLabel.Size = UDim2.new(1, -20, 0, 22); ignLabel.Position = UDim2.new(0, 10, 0, 166)
ignLabel.BackgroundTransparency = 1; ignLabel.Font = Enum.Font.Gotham; ignLabel.TextSize = 14
ignLabel.TextColor3 = Color3.fromRGB(200,200,200); ignLabel.Text = "Ignore list (comma-separated names or ids)"

local ignBox = Instance.new("TextBox", leftPanel)
ignBox.Size = UDim2.new(1, -20, 0, 34); ignBox.Position = UDim2.new(0, 10, 0, 194)
ignBox.BackgroundColor3 = Color3.fromRGB(40,44,52); ignBox.TextColor3 = Color3.fromRGB(220,220,220)
ignBox.Text = "" ; ignBox.Font = Enum.Font.Gotham; ignBox.TextSize = 16
local ignCorner = Instance.new("UICorner", ignBox); ignCorner.CornerRadius = UDim.new(0,8)

local addIgnBtn = Instance.new("TextButton", leftPanel)
addIgnBtn.Size = UDim2.new(0, 120, 0, 34); addIgnBtn.Position = UDim2.new(0, 10, 1, -54)
addIgnBtn.Text = "Add Ignore"; addIgnBtn.Font = Enum.Font.GothamBold; addIgnBtn.TextSize = 14
addIgnBtn.BackgroundColor3 = Color3.fromRGB(75,130,220); addIgnBtn.TextColor3 = Color3.fromRGB(255,255,255)
local addIgnCorner = Instance.new("UICorner", addIgnBtn); addIgnCorner.CornerRadius = UDim.new(0,8)

local clearIgnBtn = Instance.new("TextButton", leftPanel)
clearIgnBtn.Size = UDim2.new(0, 120, 0, 34); clearIgnBtn.Position = UDim2.new(1, -130, 1, -54)
clearIgnBtn.AnchorPoint = Vector2.new(0,0); clearIgnBtn.Text = "Clear List"; clearIgnBtn.Font = Enum.Font.GothamBold
clearIgnBtn.TextSize = 14; clearIgnBtn.BackgroundColor3 = Color3.fromRGB(65,65,70); clearIgnBtn.TextColor3 = Color3.fromRGB(255,255,255)
local clearIgnCorner = Instance.new("UICorner", clearIgnBtn); clearIgnCorner.CornerRadius = UDim.new(0,8)

-- Ignore list UI (scroll)
local ignLabel2 = Instance.new("TextLabel", leftPanel)
ignLabel2.Size = UDim2.new(1, -20, 0, 22); ignLabel2.Position = UDim2.new(0, 10, 0, 236)
ignLabel2.BackgroundTransparency = 1; ignLabel2.Font = Enum.Font.Gotham; ignLabel2.TextSize = 14
ignLabel2.TextColor3 = Color3.fromRGB(180,180,180); ignLabel2.Text = "Current Ignore List:"

local ignScroll = Instance.new("ScrollingFrame", leftPanel)
ignScroll.Size = UDim2.new(1, -20, 0, 86); ignScroll.Position = UDim2.new(0, 10, 0, 262)
ignScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ignScroll.ScrollBarThickness = 6
ignScroll.BackgroundTransparency = 1
local ignLayout = Instance.new("UIListLayout", ignScroll)
ignLayout.SortOrder = Enum.SortOrder.LayoutOrder
ignLayout.Padding = UDim.new(0,6)

-- ===== RIGHT PANEL (live list with columns) =====
local rightPanel = Instance.new("Frame", main)
rightPanel.Size = UDim2.new(1, -leftW - 32, 1, -90)
rightPanel.Position = UDim2.new(0, leftW + 16, 0, 74)
rightPanel.BackgroundTransparency = 1

local columns = Instance.new("Frame", rightPanel)
columns.Size = UDim2.new(1, 0, 0, 28)
columns.Position = UDim2.new(0, 0, 0, 0)
columns.BackgroundTransparency = 1

local colName = Instance.new("TextLabel", columns)
colName.Size = UDim2.new(0.6, -6, 1, 0); colName.Position = UDim2.new(0, 6, 0, 0)
colName.BackgroundTransparency = 1; colName.Font = Enum.Font.GothamBold; colName.TextSize = 14
colName.Text = "Brainrot"; colName.TextColor3 = Color3.fromRGB(210,210,210); colName.TextXAlignment = Enum.TextXAlignment.Left

local colMoney = colName:Clone(); colMoney.Parent = columns
colMoney.Size = UDim2.new(0.4, -6, 1, 0); colMoney.Position = UDim2.new(0.6, 6, 0, 0)
colMoney.Text = "Money / sec"; colMoney.TextXAlignment = Enum.TextXAlignment.Right

-- scrolling frame for entries
local listFrame = Instance.new("ScrollingFrame", rightPanel)
listFrame.Size = UDim2.new(1, 0, 1, -28)
listFrame.Position = UDim2.new(0, 0, 0, 28)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 8
local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,6)

-- stores entries by id
local entries = {}

-- helper to refresh canvas size
local function refreshCanvas()
    listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    ignScroll.CanvasSize = UDim2.new(0, 0, 0, ignLayout.AbsoluteContentSize.Y + 12)
end

-- add an entry (id must be unique)
local function addEntry(payload)
    if not payload or not payload.id then return end
    -- if exists, update
    if entries[payload.id] then
        local row = entries[payload.id]
        row.NameLabel.Text = payload.name or row.NameLabel.Text
        row.MoneyLabel.Text = tostring(payload.money or row.MoneyLabel.Text)
        return
    end
    local row = Instance.new("Frame", listFrame)
    row.Size = UDim2.new(1, -8, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(26,28,32)
    row.BorderSizePixel = 0
    local rc = Instance.new("UICorner", row); rc.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(0.6, -12, 1, 0)
    nameLbl.Position = UDim2.new(0, 8, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 16
    nameLbl.TextColor3 = Color3.fromRGB(235,235,235)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = tostring(payload.name or "Unknown")

    local moneyLbl = Instance.new("TextLabel", row)
    moneyLbl.Size = UDim2.new(0.4, -12, 1, 0)
    moneyLbl.Position = UDim2.new(0.6, 8, 0, 0)
    moneyLbl.BackgroundTransparency = 1
    moneyLbl.Font = Enum.Font.GothamSemibold; moneyLbl.TextSize = 16
    moneyLbl.TextColor3 = Color3.fromRGB(170,210,255)
    moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Text = tostring(payload.money or "0")

    -- clickable overlay to "request join" (safe: fires remote to server)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        -- client requested join for this entry - server must decide how to handle
        pcall(function()
            remoteRequest:FireServer({ id = payload.id, name = payload.name, money = payload.money })
        end)
        statusLabel.Text = "Status: Requested join for "..tostring(payload.name)
        delay(2, function() statusLabel.Text = "Status: Idle" end)
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

-- expose global API to add/remove entries locally
local public = {}
public.AddEntry = addEntry
public.RemoveEntry = removeEntry

-- listen to RemoteEvents from server
remoteAdd.OnClientEvent:Connect(function(payload)
    -- payload expected: { id=..., name=..., money=... }
    addEntry(payload)
end)
remoteRemove.OnClientEvent:Connect(function(payload)
    if payload and payload.id then removeEntry(payload.id) end
end)

-- IGNORE list handling
local ignoreList = {}
local function rebuildIgnoreUI()
    -- clear children
    for _,c in ipairs(ignScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    for i, item in ipairs(ignoreList) do
        local t = Instance.new("Frame", ignScroll)
        t.Size = UDim2.new(1, 0, 0, 28); t.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", t)
        lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1; lbl.Text = tostring(item); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220); lbl.TextXAlignment = Enum.TextXAlignment.Left

        local rem = Instance.new("TextButton", t)
        rem.Size = UDim2.new(0, 32, 0, 24); rem.Position = UDim2.new(1, -36, 0, 2); rem.Text = "X"; rem.Font = Enum.Font.GothamBold
        rem.TextSize = 14; rem.BackgroundColor3 = Color3.fromRGB(70,70,70); rem.TextColor3 = Color3.fromRGB(255,255,255)
        local rc = Instance.new("UICorner", rem); rc.CornerRadius = UDim.new(0,6)
        rem.MouseButton1Click:Connect(function()
            for idx,v in ipairs(ignoreList) do if v == item then table.remove(ignoreList, idx); break end end
            rebuildIgnoreUI()
            setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
        end)
    end
    refreshCanvas()
end

-- load ignore list from attribute (comma separated)
local function loadIgnore()
    local s = getAttr("NAJ.IgnoreList", "")
    ignoreList = {}
    if s ~= "" then
        for part in s:gmatch("[^,]+") do
            local trimmed = part:gsub("^%s*(.-)%s*$", "%1")
            if trimmed ~= "" then table.insert(ignoreList, trimmed) end
        end
    end
    rebuildIgnoreUI()
end
loadIgnore()

-- add ignore button
addIgnBtn.MouseButton1Click:Connect(function()
    local text = tostring(ignBox.Text or "")
    if text == "" then return end
    for part in text:gmatch("[^,]+") do
        local trimmed = part:gsub("^%s*(.-)%s*$", "%1")
        if trimmed ~= "" then table.insert(ignoreList, trimmed) end
    end
    ignBox.Text = ""
    setAttr("NAJ.IgnoreList", table.concat(ignoreList, ","))
    rebuildIgnoreUI()
end)

clearIgnBtn.MouseButton1Click:Connect(function()
    ignoreList = {}
    setAttr("NAJ.IgnoreList", "")
    rebuildIgnoreUI()
end)

-- auto toggle behavior
local function applyAutoState(val)
    setAttr("NAJ.AutoJoin", val)
    autoToggle.Text = val and "ON" or "OFF"
    autoToggle.BackgroundColor3 = val and Color3.fromRGB(80,170,80) or Color3.fromRGB(60,60,64)
    if val then
        statusLabel.Text = "Status: AutoJoin ON"
    else
        statusLabel.Text = "Status: Idle"
    end
    delay(2, function() if statusLabel then statusLabel.Text = "Status: Idle" end end)
end

autoToggle.MouseButton1Click:Connect(function()
    local cur = getAttr("NAJ.AutoJoin", false)
    applyAutoState(not cur)
end)

-- save min box on focus lost
minBox.FocusLost:Connect(function(enter)
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", n)
    minBox.Text = tostring(n)
end)

-- Save button (applies theme values)
local function applyThemeFromStored()
    local r = getAttr("NAJ.ThemeR", 34); local g = getAttr("NAJ.ThemeG", 106); local b = getAttr("NAJ.ThemeB", 255)
    local col = Color3.new(r, g, b)
    -- subtle theme apply (we use topbar background color)
    -- convert Color3 from 0-1 to 0-255 if necessary
    if r <= 1 and g <= 1 and b <= 1 then col = Color3.new(r, g, b) end
    BarApplyColor = col
    -- we'll set main topbar via BarApplyColor variable below
end
applyThemeFromStored()

-- Save button for color and min/max (we add a small Save near min)
local saveBtn = Instance.new("TextButton", leftPanel)
saveBtn.Size = UDim2.new(0, leftW - 24, 0, 36)
saveBtn.Position = UDim2.new(0, 12, 1, -46)
saveBtn.Text = "Save Settings"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 16
saveBtn.BackgroundColor3 = Color3.fromRGB(70,130,210)
local saveCorner = Instance.new("UICorner", saveBtn); saveCorner.CornerRadius = UDim.new(0,8)

saveBtn.MouseButton1Click:Connect(function()
    -- store theme currently from Bar background (convert to components)
    local c = main.BackgroundColor3 -- we won't change whole main bg, but store min and ignore
    local minN = tonumber(minBox.Text) or 0
    setAttr("NAJ.MinPerSec", math.max(0, math.floor(minN)))
    setAttr("NAJ.MaxPerSec", 999999999999999) -- unlimited as requested
    setAttr("NAJ.ThemeR", currentTheme().R); setAttr("NAJ.ThemeG", currentTheme().G); setAttr("NAJ.ThemeB", currentTheme().B)
    StatusLabel.Text = "Status: Settings saved"
    delay(1.8, function() if StatusLabel then StatusLabel.Text = "Status: Idle" end end)
end)

-- Make window draggable (works even when minimized)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Minimize behavior: collapse to topbar only
local minimized = false
local function minimize()
    if minimized then return end
    minimized = true
    -- tween size to topbar size
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(520, 70)}):Play()
end
local function restore()
    if not minimized then return end
    minimized = false
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(MAIN_W, MAIN_H)}):Play()
end

minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then restore() else minimize() end
end)

-- Ensure UI persists after respawn: reapply attributes on CharacterAdded
player.CharacterAdded:Connect(function()
    -- re-apply stored values
    applyAutoState(getAttr("NAJ.AutoJoin", false))
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
    -- re-add entries if server will send them again; otherwise entries persist client-side
end)

-- Public API: allow local code to add/remove entries
-- usage: require or call via screenGui:FindFirstChild("NicholasAJ_API")...
local apiFolder = screenGui:FindFirstChild("NicholasAJ_API")
if apiFolder then apiFolder:Destroy() end
apiFolder = Instance.new("Folder", screenGui); apiFolder.Name = "NicholasAJ_API"

local bindAdd = Instance.new("BindableFunction", apiFolder); bindAdd.Name = "AddEntry"
bindAdd.OnInvoke = function(payload) addEntry(payload) end
local bindRem = Instance.new("BindableFunction", apiFolder); bindRem.Name = "RemoveEntry"
bindRem.OnInvoke = function(id) removeEntry(id) end

-- Also expose global table (convenience)
_G.NicholasAJ = _G.NicholasAJ or {}
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry
_G.NicholasAJ.List = entries

-- Quick demo/test entries if running in Studio (will not run on live)
if RUN_SERVICE == nil then
    -- running in normal environment; but we can optionally add a small demo if Studio
    pcall(function()
        if game:GetService("RunService"):IsStudio() then
            addEntry({ id = "demo1", name = "Brainrot A", money = "10,000,000" })
            addEntry({ id = "demo2", name = "Brainrot B", money = "2,500,000" })
        end
    end)
end

-- Final: apply initial states
applyAutoState(getAttr("NAJ.AutoJoin", false))
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
rebuildIgnoreUI()
refreshCanvas()

-- End of script — UI ready.

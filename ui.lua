-- ui.lua — Final updated UI (safe UI-only)
-- Features: navy top, big close (right), minimize (top remains), sliding toggle, smaller left panel,
-- bigger right brainrot panel, searchable ignore list auto-populated from game (best-effort).
-- Place as LocalScript in StarterPlayerScripts or upload to your repo.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent names (safe signals only)
local REMOTE_REQUEST = "NicholasAJ_RequestJoin" -- client -> server when clicking a row
local REMOTE_PUSH = "NicholasAJ_PushEntry"      -- server -> client to push an entry (optional)

-- ensure local RemoteEvent objects exist so script won't error if server doesn't create them
local function ensureRemote(name)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if obj and obj:IsA("RemoteEvent") then return obj end
    local re = Instance.new("RemoteEvent")
    re.Name = name
    re.Parent = ReplicatedStorage
    return re
end
local remoteRequest = ensureRemote(REMOTE_REQUEST)
local remotePush = ensureRemote(REMOTE_PUSH)

-- Attribute helpers (persist across respawns)
local function setAttr(k,v) if player:GetAttribute(k) ~= v then player:SetAttribute(k, v) end end
local function getAttr(k,def) local v = player:GetAttribute(k) if v == nil then return def end return v end

-- defaults
if getAttr("NAJ.MinPerSec", nil) == nil then setAttr("NAJ.MinPerSec", 0) end
if getAttr("NAJ.AutoJoin", nil) == nil then setAttr("NAJ.AutoJoin", false) end
if getAttr("NAJ.IgnoreList", nil) == nil then setAttr("NAJ.IgnoreList", "") end

-- remove old GUI if present
local GUI_NAME = "NicholasAJ_UI_Final_v3"
local existing = playerGui:FindFirstChild(GUI_NAME)
if existing then existing:Destroy() end

-- create screen gui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- sizes (bigger overall per request)
local WIDTH, HEIGHT = 760, 520
local LEFT_W = 200 -- smaller left features panel
local TOP_H = 56   -- top bar slightly smaller
local PADDING = 14
local NAVY = Color3.fromRGB(7, 24, 54) -- dark navy

-- main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.12, 0)
main.AnchorPoint = Vector2.new(0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
main.BorderSizePixel = 0
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 16)
main.ClipsDescendants = true

-- drop shadow (soft)
local shadow = Instance.new("Frame", screenGui)
shadow.Name = "Shadow"
shadow.Size = main.Size + UDim2.new(0,10,0,10)
shadow.Position = main.Position + UDim2.new(0,5,0,5)
shadow.AnchorPoint = main.AnchorPoint
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BorderSizePixel = 0
shadow.ZIndex = main.ZIndex - 1
local shadowCorner = Instance.new("UICorner", shadow); shadowCorner.CornerRadius = UDim.new(0,18)
shadow.BackgroundTransparency = 0.72

-- animated rainbow outline
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

-- TOP BAR (navy)
local top = Instance.new("Frame", main)
top.Name = "Top"
top.Size = UDim2.new(1, 0, 0, TOP_H)
top.Position = UDim2.new(0, 0, 0, 0)
top.BackgroundColor3 = NAVY
top.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", top); topCorner.CornerRadius = UDim.new(0, 16)

-- Title and big Discord (moved/ larger)
local title = Instance.new("TextLabel", top)
title.Name = "Title"
title.Size = UDim2.new(0, 420, 0, 24)
title.Position = UDim2.new(0, 18, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Text = "Nicolas's Autojoiner"

local discord = Instance.new("TextLabel", top)
discord.Name = "Discord"
discord.Size = UDim2.new(0, 420, 0, 20)
discord.Position = UDim2.new(0, 18, 0, 28)
discord.BackgroundTransparency = 1
discord.Font = Enum.Font.GothamSemibold
discord.TextSize = 15
discord.TextColor3 = Color3.fromRGB(205,225,255)
discord.Text = "discord.gg/Kzzwxg89"
discord.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE (left small pill)
local minBtn = Instance.new("TextButton", top)
minBtn.Name = "Min"
minBtn.Size = UDim2.new(0, 34, 0, 26)
minBtn.Position = UDim2.new(0, 8, 0, 14)
minBtn.BackgroundColor3 = Color3.fromRGB(90,90,95)
minBtn.Text = "–"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0,6)
minBtn.ZIndex = top.ZIndex + 2

-- CLOSE (big red on right)
local closeBtn = Instance.new("TextButton", top)
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 46, 0, 30)
closeBtn.Position = UDim2.new(1, -56, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner", closeBtn); closeCorner.CornerRadius = UDim.new(0,8)
closeBtn.ZIndex = top.ZIndex + 2

-- top divider (yellow)
local topDiv = Instance.new("Frame", main)
topDiv.Name = "TopDivider"
topDiv.Size = UDim2.new(1, 0, 0, 4)
topDiv.Position = UDim2.new(0, 0, 0, TOP_H)
topDiv.BackgroundColor3 = Color3.fromRGB(246,196,0)
topDiv.BorderSizePixel = 0

-- LEFT FEATURES (smaller)
local left = Instance.new("Frame", main)
left.Name = "Left"
left.Size = UDim2.new(0, LEFT_W, 1, -TOP_H - (PADDING*1.5))
left.Position = UDim2.new(0, PADDING, 0, TOP_H + (PADDING/2))
left.BackgroundColor3 = Color3.fromRGB(20,22,30)
left.BorderSizePixel = 0
local leftCorner = Instance.new("UICorner", left); leftCorner.CornerRadius = UDim.new(0,10)

-- vertical yellow separator connecting panels
local vertSep = Instance.new("Frame", main)
vertSep.Name = "VertSep"
vertSep.Size = UDim2.new(0, 4, 1, -TOP_H - (PADDING*1.5))
vertSep.Position = UDim2.new(0, LEFT_W + (PADDING*1.5), 0, TOP_H + (PADDING/2))
vertSep.BackgroundColor3 = Color3.fromRGB(246,196,0)
vertSep.BorderSizePixel = 0

-- LEFT HEADER
local leftHeader = Instance.new("TextLabel", left)
leftHeader.Size = UDim2.new(1, -24, 0, 22)
leftHeader.Position = UDim2.new(0, 12, 0, 8)
leftHeader.BackgroundTransparency = 1
leftHeader.Font = Enum.Font.GothamBold
leftHeader.TextSize = 14
leftHeader.TextColor3 = Color3.fromRGB(230,230,230)
leftHeader.Text = "AUTOJOIN"

-- sliding toggle (visual left-right)
local function makeSlidingToggle(parent, rightOffset)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0, 58, 0, 30)
    container.Position = UDim2.new(1, - (rightOffset or 70), 0, 6)
    container.BackgroundColor3 = Color3.fromRGB(24,24,28)
    container.BorderSizePixel = 0
    local cCorner = Instance.new("UICorner", container); cCorner.CornerRadius = UDim.new(0, 8)
    local track = Instance.new("Frame", container)
    track.Size = UDim2.new(1, -8, 0, 18)
    track.Position = UDim2.new(0, 4, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(40,40,44)
    local tCorner = Instance.new("UICorner", track); tCorner.CornerRadius = UDim.new(0,9)
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0,2,0,0)
    knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
    knob.ZIndex = container.ZIndex + 2
    local kCorner = Instance.new("UICorner", knob); kCorner.CornerRadius = UDim.new(0,9)
    return container, track, knob
end

-- Autojoin card
local autoCard = Instance.new("Frame", left)
autoCard.Size = UDim2.new(1, -24, 0, 44)
autoCard.Position = UDim2.new(0, 12, 0, 44)
autoCard.BackgroundColor3 = Color3.fromRGB(28,30,34)
local acorner = Instance.new("UICorner", autoCard); acorner.CornerRadius = UDim.new(0,8)
local autoLabel = Instance.new("TextLabel", autoCard)
autoLabel.Size = UDim2.new(0.66, -8, 1, 0)
autoLabel.Position = UDim2.new(0, 8, 0, 0)
autoLabel.BackgroundTransparency = 1
autoLabel.Font = Enum.Font.Gotham
autoLabel.TextSize = 14
autoLabel.TextColor3 = Color3.fromRGB(220,220,220)
autoLabel.Text = "Auto Join"

local sliderContainer, sliderTrack, sliderKnob = makeSlidingToggle(autoCard, 64)
-- initial position from attribute
local function setSliderState(on)
    if on then
        TweenService:Create(sliderKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -20, 0, 0)}):Play()
        sliderTrack.BackgroundColor3 = NAVY
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    else
        TweenService:Create(sliderKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = UDim2.new(0,2,0,0)}):Play()
        sliderTrack.BackgroundColor3 = Color3.fromRGB(40,40,44)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(170,170,170)
    end
end

local currentAuto = getAttr("NAJ.AutoJoin", false)
setSliderState(currentAuto)

sliderContainer.MouseButton1Click = nil -- not a button; use input connection
sliderContainer.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        currentAuto = not currentAuto
        setAttr("NAJ.AutoJoin", currentAuto)
        setSliderState(currentAuto)
    end
end)

-- MONEY FILTER (Min only)
local minHeader = Instance.new("TextLabel", left)
minHeader.Size = UDim2.new(1, -24, 0, 20)
minHeader.Position = UDim2.new(0, 12, 0, 104)
minHeader.BackgroundTransparency = 1
minHeader.Font = Enum.Font.GothamBold
minHeader.TextSize = 13
minHeader.TextColor3 = Color3.fromRGB(220,220,220)
minHeader.Text = "MONEY FILTER"

local minCard = Instance.new("Frame", left)
minCard.Size = UDim2.new(1, -24, 0, 40)
minCard.Position = UDim2.new(0, 12, 0, 132)
minCard.BackgroundColor3 = Color3.fromRGB(28,30,34)
local minCorner = Instance.new("UICorner", minCard); minCorner.CornerRadius = UDim.new(0,8)
local minLabel = Instance.new("TextLabel", minCard)
minLabel.Size = UDim2.new(0.6, -8, 1, 0)
minLabel.Position = UDim2.new(0, 8, 0, 0)
minLabel.BackgroundTransparency = 1; minLabel.Font = Enum.Font.Gotham; minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(210,210,210); minLabel.Text = "Min M/S"
local minBox = Instance.new("TextBox", minCard)
minBox.Size = UDim2.new(0.34, -12, 0, 28)
minBox.Position = UDim2.new(1, -86, 0, 6)
minBox.BackgroundColor3 = Color3.fromRGB(34,36,40)
minBox.TextColor3 = Color3.fromRGB(220,220,220)
minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
minBox.Font = Enum.Font.Gotham; minBox.TextSize = 14
local minBoxCorner = Instance.new("UICorner", minBox); minBoxCorner.CornerRadius = UDim.new(0,6)
minBox.FocusLost:Connect(function()
    local n = tonumber(minBox.Text) or 0
    if n < 0 then n = 0 end
    setAttr("NAJ.MinPerSec", math.floor(n))
    minBox.Text = tostring(math.floor(n))
end)

-- IGNORE SETTINGS header + big searchable list (auto-populates)
local ignHeader = Instance.new("TextLabel", left)
ignHeader.Size = UDim2.new(1, -24, 0, 20)
ignHeader.Position = UDim2.new(0, 12, 0, 184)
ignHeader.BackgroundTransparency = 1
ignHeader.Font = Enum.Font.GothamBold
ignHeader.TextSize = 13
ignHeader.TextColor3 = Color3.fromRGB(220,220,220)
ignHeader.Text = "IGNORE SETTINGS"

local brainListFrame = Instance.new("Frame", left)
brainListFrame.Size = UDim2.new(1, -24, 0, 220)
brainListFrame.Position = UDim2.new(0, 12, 0, 210)
brainListFrame.BackgroundTransparency = 1

local searchBox = Instance.new("TextBox", brainListFrame)
searchBox.Size = UDim2.new(1, 0, 0, 28)
searchBox.Position = UDim2.new(0, 0, 0, 0)
searchBox.PlaceholderText = "Search brainrots..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.BackgroundColor3 = Color3.fromRGB(30,32,40)
searchBox.TextColor3 = Color3.fromRGB(230,230,230)
local searchCorner = Instance.new("UICorner", searchBox); searchCorner.CornerRadius = UDim.new(0,6)

local scrollList = Instance.new("ScrollingFrame", brainListFrame)
scrollList.Size = UDim2.new(1, 0, 1, -34)
scrollList.Position = UDim2.new(0, 0, 0, 34)
scrollList.BackgroundTransparency = 1
scrollList.ScrollBarThickness = 8
local scrollLayout = Instance.new("UIListLayout", scrollList)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0,6)

-- ignored set tracked and persisted
local ignoredSet = {}
local function loadIgnored()
    ignoredSet = {}
    local raw = getAttr("NAJ.IgnoreList", "")
    if raw ~= "" then
        for s in raw:gmatch("[^,]+") do
            local t = s:gsub("^%s*(.-)%s*$","%1")
            if t ~= "" then ignoredSet[t] = true end
        end
    end
end
loadIgnored()

-- populate brainrot names automatically (best-effort)
local function gatherBrainrotNames()
    local namesSet = {}
    -- 1) ReplicatedStorage common folders
    local rs = ReplicatedStorage
    local candidates = {"Brainrots", "BrainrotData", "Pets", "Items", "Collectibles"}
    for _,n in ipairs(candidates) do
        local folder = rs:FindFirstChild(n)
        if folder and folder:IsA("Folder") then
            for _,child in ipairs(folder:GetChildren()) do
                if child.Name and not namesSet[child.Name] then
                    namesSet[child.Name] = true
                end
                -- try common fields
                if child:FindFirstChild("DisplayName") and child.DisplayName:IsA("StringValue") then
                    namesSet[child.DisplayName.Value] = true
                end
            end
        end
    end
    -- 2) CollectionService tags
    local tagged = CollectionService:GetTagged("Brainrot")
    for _,v in ipairs(tagged) do
        if v.Name and not namesSet[v.Name] then namesSet[v.Name] = true end
    end
    -- 3) Search workspace for models with "Brainrot" or "Brain Rot" keyword in name or attributes
    local function checkInstance(inst)
        if inst.Name and (inst.Name:lower():find("brainrot") or inst.Name:lower():find("brain rot") or inst.Name:lower():find("brain")) then
            namesSet[inst.Name] = true
        end
        if inst:FindFirstChild("DisplayName") and inst.DisplayName:IsA("StringValue") then
            namesSet[inst.DisplayName.Value] = true
        end
    end
    for _,inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("Model") or inst:IsA("Folder") or inst:IsA("ValueBase") then
            checkInstance(inst)
        end
    end
    -- 4) Fallback: if no data, return demo list
    local result = {}
    for k,_ in pairs(namesSet) do table.insert(result, k) end
    table.sort(result)
    if #result == 0 then
        result = {"Secret Brainrot A","Secret Brainrot B","OG Brainrot 1","Ultra OG Brainrot","Classic Brainrot"}
    end
    return result
end

local brainrotNames = gatherBrainrotNames()

-- build scroll list UI rows from brainrotNames, with search filter
local brainEntries = {}
local function rebuildScroll(filter)
    for _,c in ipairs(scrollList:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    brainEntries = {}
    for _,name in ipairs(brainrotNames) do
        if not filter or filter == "" or name:lower():find(filter:lower()) then
            local row = Instance.new("Frame", scrollList)
            row.Size = UDim2.new(1, 0, 0, 28)
            row.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0.7, 0, 1, 0)
            lbl.Position = UDim2.new(0, 6, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(230,230,230)
            lbl.Text = name
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(0.28, -8, 0, 22)
            btn.Position = UDim2.new(1, -8, 0, 3)
            btn.AnchorPoint = Vector2.new(1, 0)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.BorderSizePixel = 0
            local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0,6)
            -- initial state
            if ignoredSet[name] then
                btn.BackgroundColor3 = NAVY
                btn.Text = "IGNORED"
                btn.TextColor3 = Color3.fromRGB(255,255,255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(36,36,40)
                btn.Text = "IGNORE"
                btn.TextColor3 = Color3.fromRGB(200,200,200)
            end
            btn.MouseButton1Click:Connect(function()
                if ignoredSet[name] then
                    ignoredSet[name] = nil
                    btn.BackgroundColor3 = Color3.fromRGB(36,36,40)
                    btn.Text = "IGNORE"
                    btn.TextColor3 = Color3.fromRGB(200,200,200)
                else
                    ignoredSet[name] = true
                    btn.BackgroundColor3 = NAVY
                    btn.Text = "IGNORED"
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                end
                local parts = {}
                for k,_ in pairs(ignoredSet) do table.insert(parts, k) end
                setAttr("NAJ.IgnoreList", table.concat(parts, ","))
            end)
            brainEntries[name] = {Row = row, Label = lbl, Button = btn}
        end
    end
    scrollList.CanvasSize = UDim2.new(0,0,0, (scrollList:GetChildren() and (scrollList.UIListLayout and scrollList.UIListLayout.AbsoluteContentSize.Y or 0) or 0))
    -- ensure UIListLayout exists
    local found = false
    for _,c in ipairs(scrollList:GetChildren()) do if c:IsA("UIListLayout") then found = true break end end
    if not found then
        local ul = Instance.new("UIListLayout", scrollList); ul.SortOrder = Enum.SortOrder.LayoutOrder; ul.Padding = UDim.new(0,6)
    end
end

rebuildScroll()

-- search filtering
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildScroll(searchBox.Text)
end)

-- RIGHT PANEL (bigger)
local right = Instance.new("Frame", main)
right.Name = "Right"
right.Size = UDim2.new(1, -LEFT_W - (PADDING*3) - 8, 1, -TOP_H - (PADDING*2))
right.Position = UDim2.new(0, LEFT_W + (PADDING*2) + 4, 0, TOP_H + (PADDING/1.25))
right.BackgroundTransparency = 1

-- header row
local headerFrame = Instance.new("Frame", right)
headerFrame.Size = UDim2.new(1, 0, 0, 34)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1
local hName = Instance.new("TextLabel", headerFrame)
hName.Size = UDim2.new(0.62, -8, 1, 0); hName.Position = UDim2.new(0, 12, 0, 0)
hName.BackgroundTransparency = 1; hName.Font = Enum.Font.GothamBold; hName.TextSize = 15
hName.Text = "Brainrot"; hName.TextColor3 = Color3.fromRGB(220,220,220); hName.TextXAlignment = Enum.TextXAlignment.Left
local hMoney = hName:Clone(); hMoney.Parent = headerFrame
hMoney.Size = UDim2.new(0.38, -8, 1, 0); hMoney.Position = UDim2.new(0.62, 8, 0, 0)
hMoney.Text = "Money / sec"; hMoney.TextXAlignment = Enum.TextXAlignment.Right

-- right list scrolling
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1, 0, 1, -34)
list.Position = UDim2.new(0, 0, 0, 34)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 10
local listLayout = Instance.new("UIListLayout", list)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

-- store entries
local entries = {}
local function refreshCanvas()
    list.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 12)
end

local function addEntry(payload)
    -- payload: { id=string, name=string, money=string/number }
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
    local rowCorner = Instance.new("UICorner", row); rowCorner.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(0.62, -12, 1, 0); nameLbl.Position = UDim2.new(0, 12, 0, 0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 15
    nameLbl.TextColor3 = Color3.fromRGB(235,235,235); nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = tostring(payload.name or "Unknown")

    local moneyLbl = Instance.new("TextLabel", row)
    moneyLbl.Size = UDim2.new(0.38, -12, 1, 0); moneyLbl.Position = UDim2.new(0.62, 8, 0, 0)
    moneyLbl.BackgroundTransparency = 1; moneyLbl.Font = Enum.Font.GothamSemibold; moneyLbl.TextSize = 15
    moneyLbl.TextColor3 = Color3.fromRGB(160,200,255); moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Text = tostring(payload.money or "0")

    local sep = Instance.new("Frame", row)
    sep.Size = UDim2.new(1, -20, 0, 1)
    sep.Position = UDim2.new(0, 10, 1, -8)
    sep.BackgroundColor3 = Color3.fromRGB(45,45,50)
    sep.BorderSizePixel = 0

    local overlay = Instance.new("TextButton", row)
    overlay.Size = UDim2.new(1, 0, 1, 0); overlay.BackgroundTransparency = 1; overlay.Text = ""; overlay.AutoButtonColor = true
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
_G.NicholasAJ.SetBrainrotList = function(names)
    brainrotNames = names or {}
    table.sort(brainrotNames)
    rebuildScroll(searchBox.Text or "")
end
_G.NicholasAJ.AddEntry = addEntry
_G.NicholasAJ.RemoveEntry = removeEntry

-- remote push handler
remotePush.OnClientEvent:Connect(function(payload)
    if payload and payload.id then addEntry(payload) end
end)

-- demo in Studio (visible if running in Studio)
pcall(function()
    if RunService:IsStudio() then
        _G.NicholasAJ.SetBrainrotList({"Ultra OG","Secret C","Classic OG","Crown Brainrot","Rare Blue"})
        addEntry({ id = "demo1", name = "Ultra OG", money = "60,000,000" })
        addEntry({ id = "demo2", name = "Secret C", money = "7,500,000" })
    end
end)

-- interactions: minimize, close, slider already set partly
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in ipairs(main:GetChildren()) do
        if v ~= top and v ~= topDiv and v ~= stroke then
            v.Visible = not minimized
        end
    end
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, TOP_H + 8)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = main.Size + UDim2.new(0,10,0,10), Position = main.Position + UDim2.new(0,5,0,5)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WIDTH, HEIGHT)}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = main.Size + UDim2.new(0,10,0,10), Position = main.Position + UDim2.new(0,5,0,5)}):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    -- full close: destroy GUI (top disappears as well)
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end)

-- dragging top bar (works when minimized)
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
        shadow.Position = main.Position + UDim2.new(0,5,0,5)
    end
end)

-- restore attributes on respawn
player.CharacterAdded:Connect(function()
    minBox.Text = tostring(getAttr("NAJ.MinPerSec", 0))
    local cur = getAttr("NAJ.AutoJoin", false)
    setSliderState(cur)
    loadIgnored()
    rebuildScroll(searchBox.Text or "")
end)

print("[NicholasAJ] UI ready (v3)")


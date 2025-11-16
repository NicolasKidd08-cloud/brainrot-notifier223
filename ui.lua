-- ui.lua
-- Nicolas's Auto-Joiner (Upgraded UI, safe UI-only)
-- Size: 600 x 500 (longer / less wide)
-- NOTE: This file only implements UI and simulated retry behavior. NO exploit/auto-join network actions.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local PLAYER = Players.LocalPlayer
local PLAYERGUI = PLAYER:WaitForChild("PlayerGui")

-- Config
local WIDTH, HEIGHT = 600, 500
local DISCORD_INVITE = "https://discord.gg/pAgSFBKj"
local MAX_RETRIES = 30
local RETRY_INTERVAL = 1 -- seconds between simulated retries

-- Utility: create ancestor ScreenGui container
local function createScreenGui(name)
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ResetOnSpawn = false
    sg.Parent = PLAYERGUI
    return sg
end

-- Clear any previous instance (helps when reloading)
for _, v in ipairs(PLAYERGUI:GetChildren()) do
    if v.Name == "NicolasAutoJoinerGUI" then
        v:Destroy()
    end
end

local screenGui = createScreenGui("NicolasAutoJoinerGUI")

-- Main container frame
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
main.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 90, 255) -- blue background
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow outline (UIStroke)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 4
stroke.Parent = main

-- Animate rainbow border
task.spawn(function()
    local hue = 0
    while stroke.Parent and RunService.Heartbeat:Wait() do
        hue = (hue + 0.0025) % 1
        stroke.Color = Color3.fromHSV(hue, 1, 1)
        -- small wait via Heartbeat loop above
    end
end)

-- Make draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(main)

-- Top bar (thicker)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 64) -- thicker top
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(12, 34, 140)
topBar.BorderSizePixel = 0
topBar.Parent = main
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

-- Title label
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nicolas's Auto-Joiner"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Minimized/Collapsed strip's label (will be reused)
local collapsedStrip = Instance.new("Frame")
collapsedStrip.Name = "CollapsedStrip"
collapsedStrip.Size = UDim2.new(0, 220, 0, 44)
collapsedStrip.Position = UDim2.new(0.5, -110, 0, 8)
collapsedStrip.AnchorPoint = Vector2.new(0.5, 0)
collapsedStrip.BackgroundColor3 = Color3.fromRGB(20, 90, 255)
collapsedStrip.BorderSizePixel = 0
collapsedStrip.Visible = false
collapsedStrip.Parent = screenGui
Instance.new("UICorner", collapsedStrip).CornerRadius = UDim.new(0, 10)

local collapsedBtn = Instance.new("TextButton")
collapsedBtn.Size = UDim2.new(1, 0, 1, 0)
collapsedBtn.BackgroundTransparency = 1
collapsedBtn.Text = "Nicolas's Auto-Joiner"
collapsedBtn.Font = Enum.Font.GothamBold
collapsedBtn.TextSize = 16
collapsedBtn.TextColor3 = Color3.fromRGB(255,255,255)
collapsedBtn.Parent = collapsedStrip

-- Close (collapse) button on the top bar (X). Not destroying; only collapse.
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 48, 0, 40)
closeBtn.Position = UDim2.new(1, -56, 0, 12)
closeBtn.AnchorPoint = Vector2.new(0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- Left panel (settings)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 220, 1, -64)
leftPanel.Position = UDim2.new(0, 0, 0, 64)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = main

-- Auto Join toggle (kept, UI-only)
local function createToggle(parent, text, y)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -16, 0, 32)
    cont.Position = UDim2.new(0, 8, 0, y)
    cont.BackgroundTransparency = 1
    cont.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = cont

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 48, 0, 26)
    toggle.Position = UDim2.new(1, -52, 0, 3)
    toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggle.Text = ""
    toggle.Parent = cont
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(70,70,70)
    end)

    return toggle, function() return enabled end
end

local autoToggle = createToggle(leftPanel, "Auto Join", 12)

-- Removed Pet Name Filters (not created)

-- Minimum / Second label + textbox
local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(1, -16, 0, 24)
minLabel.Position = UDim2.new(0, 8, 0, 64)
minLabel.BackgroundTransparency = 1
minLabel.Font = Enum.Font.GothamBold
minLabel.TextSize = 16
minLabel.TextColor

end)

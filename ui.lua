--// Nicolas's Auto Joiner UI
--// Safe, UI-only, no exploit functions.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AutoJoinerUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 320)
frame.Position = UDim2.new(0.5, -190, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 60, 255)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Rainbow Outline Frame
local outline = Instance.new("UIStroke")
outline.Thickness = 3
outline.Parent = frame

-- Animate Rainbow Border
task.spawn(function()
    local hue = 0
    while task.wait(0.04) do
        hue = (hue + 0.01) % 1
        outline.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Top Bar
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(15, 40, 180)
top.BorderSizePixel = 0
top.Parent = frame

Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nicolas's Auto-Joiner"
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

-- Close Button (collapses UI)
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 1, 0)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "X"
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Parent = top

-- Collapsed Bar (hidden by default)
local collapsed = Instance.new("Frame")
collapsed.Size = UDim2.new(0, 200, 0, 35)
collapsed.Position = UDim2.new(0.5, -100, 0, 20)
collapsed.BackgroundColor3 = Color3.fromRGB(20, 60, 255)
collapsed.Visible = false
collapsed.Parent = gui

local collapsedTitle = Instance.new("TextButton")
collapsedTitle.Size = UDim2.new(1, 0, 1, 0)
collapsedTitle.Text = "Nicolas's Auto-Joiner"
collapsedTitle.BackgroundTransparency = 1
collapsedTitle.TextSize = 18
collapsedTitle.Font = Enum.Font.GothamBold
collapsedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
collapsedTitle.Parent = collapsed

-- Discord Link Section
local discord = Instance.new("TextButton")
discord.Size = UDim2.new(1, -20, 0, 30)
discord.Position = UDim2.new(0, 10, 0, 60)
discord.Text = "Join Discord: https://discord.gg/pAgSFBKj"
discord.TextSize = 16
discord.Font = Enum.Font.Gotham
discord.BackgroundColor3 = Color3.fromRGB(30, 80, 255)
discord.TextColor3 = Color3.fromRGB(255, 255, 255)
discord.Parent = frame

Instance.new("UICorner", discord).CornerRadius = UDim.new(0, 6)

discord.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/pAgSFBKj")
end)

-- Minimum/Second Label
local minSecLabel = Instance.new("TextLabel")
minSecLabel.Size = UDim2.new(1, -20, 0, 30)
minSecLabel.Position = UDim2.new(0, 10, 0, 110)
minSecLabel.BackgroundTransparency = 1
minSecLabel.Text = "Minimum / Second:"
minSecLabel.TextSize = 16
minSecLabel.Font = Enum.Font.GothamBold
minSecLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
minSecLabel.Parent = frame

-- Input Box
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 35)
input.Position = UDim2.new(0, 10, 0, 145)
input.BackgroundColor3 = Color3.fromRGB(35, 90, 255)
input.PlaceholderText = "Enter minimum value..."
input.Text = ""
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.Parent = frame

Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

-- Retry Counter
local retry = Instance.new("TextLabel")
retry.Size = UDim2.new(1, -20, 0, 30)
retry.Position = UDim2.new(0, 10, 0, 190)
retry.BackgroundTransparency = 1
retry.Text = "Retry: 0 / 30"
retry.TextSize = 16
retry.Font = Enum.Font.GothamBold
retry.TextColor3 = Color3.fromRGB(255, 255, 255)
retry.Parent = frame

-- Auto Join Button (UI only)
local autoJoin = Instance.new("TextButton")
autoJoin.Size = UDim2.new(1, -20, 0, 40)
autoJoin.Position = UDim2.new(0, 10, 0, 235)
autoJoin.Text = "Start Auto-Join"
autoJoin.TextSize = 18
autoJoin.Font = Enum.Font.GothamBold
autoJoin.TextColor3 = Color3.fromRGB(255, 255, 255)
autoJoin.BackgroundColor3 = Color3.fromRGB(25, 70, 255)
autoJoin.Parent = frame

Instance.new("UICorner", autoJoin).CornerRadius = UDim.new(0, 6)

-- CLOSE LOGIC
close.MouseButton1Click:Connect(function()
    frame.Visible = false
    collapsed.Visible = true
end)

collapsedTitle.MouseButton1Click:Connect(function()
    collapsed.Visible = false
    frame.Visible = true
end)

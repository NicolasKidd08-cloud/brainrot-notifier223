-- UI ONLY | NO GAME MANIPULATION | CLEAN LUAMOR-STYLE PANEL
-- Designed to look like Luarmor Priority Layout

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "NicolasAJ_UI"
ScreenGui.Parent = game.CoreGui

-- Main Frame (Luarmor-style dimensions)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Rounded Edges
local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(0,12)

-- RAINBOW BORDER
local Border = Instance.new("UIStroke")
Border.Thickness = 2
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Border.Parent = Main

-- Rainbow Animation
task.spawn(function()
    local h = 0
    while true do
        Border.Color = Color3.fromHSV(h, 1, 1)
        h = (h + 0.002) % 1
        task.wait(0.01)
    end
end)

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(26,26,32)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

-- TOPBAR SEPARATOR
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1,0,0,2)
TopLine.Position = UDim2.new(0,0,1,-2)
TopLine.BackgroundColor3 = Color3.fromRGB(255,222,0)
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar

-- Discord LEFT
local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(0,200,1,0)
Discord.Position = UDim2.new(0,10,0,0)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/brainrotAJ"
Discord.TextColor3 = Color3.fromRGB(255,255,255)
Discord.TextXAlignment = Enum.TextXAlignment.Left
Discord.Font = Enum.Font.GothamSemibold
Discord.TextSize = 14
Discord.Parent = TopBar

-- Center Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0.5,-150,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Nicholas’s Autojoiner"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0.5,-15)
MinBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Parent = TopBar

Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,8)

local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in ipairs(Main:GetChildren()) do
        if v ~= TopBar then
            v.Visible = not minimized
        end
    end
end)

-- LEFT Feature Panel
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0,140,1,-45)
LeftPanel.Position = UDim2.new(0,0,0,45)
LeftPanel.BackgroundColor3 = Color3.fromRGB(22,22,26)
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = Main

local LeftLine = Instance.new("Frame")
LeftLine.Size = UDim2.new(0,2,1,0)
LeftLine.Position = UDim2.new(1,-2,0,0)
LeftLine.BackgroundColor3 = Color3.fromRGB(255,222,0)
LeftLine.BorderSizePixel = 0
LeftLine.Parent = LeftPanel

-- Features Title
local FeatTitle = Instance.new("TextLabel")
FeatTitle.Size = UDim2.new(1,0,0,30)
FeatTitle.Position = UDim2.new(0,0,0,0)
FeatTitle.BackgroundTransparency = 1
FeatTitle.Text = "Features"
FeatTitle.TextColor3 = Color3.fromRGB(255,255,255)
FeatTitle.Font = Enum.Font.GothamBold
FeatTitle.TextSize = 16
FeatTitle.Parent = LeftPanel

-- Main Brainrot List Area
local ListArea = Instance.new("Frame")
ListArea.Size = UDim2.new(1,-140,1,-45)
ListArea.Position = UDim2.new(0,140,0,45)
ListArea.BackgroundColor3 = Color3.fromRGB(14,14,18)
ListArea.BorderSizePixel = 0
ListArea.Parent = Main

-- Column Lines
for i=1,3 do
    local col = Instance.new("Frame")
    col.Size = UDim2.new(0,2,1,0)
    col.Position = UDim2.new(i/4,0,0,0)
    col.BackgroundColor3 = Color3.fromRGB(255,222,0)
    col.BorderSizePixel = 0
    col.Parent = ListArea
end

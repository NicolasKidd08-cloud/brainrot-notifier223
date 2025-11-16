--// Brainrot Dev UI (SAFE)
--// No exploits, no autojoin bypass, dev tools only.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local Allowed = { ["Nicolas Kidd"] = true }
if not Allowed[LocalPlayer.Name] then return end

local BrainrotEvent = ReplicatedStorage:WaitForChild("BrainrotLog")


--// Main UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "BrainrotDevUI"

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 510, 0, 375)
Main.Position = UDim2.new(0.5, -255, 0.5, -187)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)

--// TOP BAR
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = Color3.fromRGB(10, 35, 70)

local TopCorner = Instance.new("UICorner", Top)
TopCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Top)
Title.Text = "Nicolas's Autojoiner • Discord: discord.gg/yourlink"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 17

-- CLOSE BUTTON
local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 36, 0, 24)
Close.Position = UDim2.new(1, -40, 0.5, -12)
Close.Text = "-"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)

local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 6)

local Minimized = false

Close.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    if Minimized then
        Main.Size = UDim2.new(0, 510, 0, 42)
    else
        Main.Size = UDim2.new(0, 510, 0, 375)
    end
end)

-- LINE BELOW TOP BAR
local TopLine = Instance.new("Frame", Main)
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.Position = UDim2.new(0, 0, 0, 42)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 210, 0)


---------------------------------------------------------------------
--// LEFT PANEL (FEATURES)
---------------------------------------------------------------------
local Left = Instance.new("Frame", Main)
Left.Size = UDim2.new(0, 170, 1, -44)
Left.Position = UDim2.new(0, 0, 0, 44)
Left.BackgroundColor3 = Color3.fromRGB(28, 28, 28)

local LeftCorner = Instance.new("UICorner", Left)
LeftCorner.CornerRadius = UDim.new(0, 8)

-- Column line
local Separator = Instance.new("Frame", Main)
Separator.Size = UDim2.new(0, 2, 1, -44)
Separator.Position = UDim2.new(0, 170, 0, 44)
Separator.BackgroundColor3 = Color3.fromRGB(255, 210, 0)

-- Features title
local FeatureTitle = Instance.new("TextLabel", Left)
FeatureTitle.Size = UDim2.new(1, 0, 0, 30)
FeatureTitle.Text = "Autojoin Settings"
FeatureTitle.Font = Enum.Font.GothamBold
FeatureTitle.TextSize = 17
FeatureTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FeatureTitle.BackgroundTransparency = 1

---------------------------------------------------------------------
-- TOGGLE
---------------------------------------------------------------------
local ToggleBack = Instance.new("Frame", Left)
ToggleBack.Size = UDim2.new(0, 42, 0, 22)
ToggleBack.Position = UDim2.new(0, 15, 0, 45)
ToggleBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local ToggleBackCorner = Instance.new("UICorner", ToggleBack)
ToggleBackCorner.CornerRadius = UDim.new(1, 0)

local ToggleBall = Instance.new("Frame", ToggleBack)
ToggleBall.Size = UDim2.new(0, 20, 0, 20)
ToggleBall.Position = UDim2.new(0, 2, 0, 1)
ToggleBall.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local BallCorner = Instance.new("UICorner", ToggleBall)
BallCorner.CornerRadius = UDim.new(1, 0)

local ToggleText = Instance.new("TextLabel", Left)
ToggleText.Text = "Auto-Join"
ToggleText.Position = UDim2.new(0, 65, 0, 43)
ToggleText.Size = UDim2.new(0, 100, 0, 24)
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleText.Font = Enum.Font.Gotham
ToggleText.TextSize = 16
ToggleText.BackgroundTransparency = 1

local AutoJoin = false

ToggleBack.InputBegan:Connect(function()
    AutoJoin = not AutoJoin

    if AutoJoin then
        ToggleBack.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
        ToggleBall:TweenPosition(UDim2.new(1, -22, 0, 1), "Out", "Quad", 0.15)
    else
        ToggleBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleBall:TweenPosition(UDim2.new(0, 2, 0, 1), "Out", "Quad", 0.15)
    end
end)


---------------------------------------------------------------------
-- MINIMUM INPUT
---------------------------------------------------------------------
local MinLabel = Instance.new("TextLabel", Left)
MinLabel.Size = UDim2.new(1, -20, 0, 20)
MinLabel.Position = UDim2.new(0, 10, 0, 85)
MinLabel.Text = "Minimum per second:"
MinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 14
MinLabel.BackgroundTransparency = 1

local MinBox = Instance.new("TextBox", Left)
MinBox.Size = UDim2.new(1, -20, 0, 30)
MinBox.Position = UDim2.new(0, 10, 0, 110)
MinBox.PlaceholderText = "0"
MinBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 14

local MinCorner = Instance.new("UICorner", MinBox)
MinCorner.CornerRadius = UDim.new(0, 6)


---------------------------------------------------------------------
-- IGNORE LIST DROPDOWN (searchable)
---------------------------------------------------------------------
local IgnoreList = Instance.new("TextBox", Left)
IgnoreList.Size = UDim2.new(1, -20, 0, 30)
IgnoreList.Position = UDim2.new(0, 10, 0, 160)
IgnoreList.PlaceholderText = "Search brainrots..."
IgnoreList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IgnoreList.TextColor3 = Color3.fromRGB(255, 255, 255)
IgnoreList.Font = Enum.Font.Gotham
IgnoreList.TextSize = 14

local IgnoreCorner = Instance.new("UICorner", IgnoreList)
IgnoreCorner.CornerRadius = UDim.new(0, 6)


---------------------------------------------------------------------
-- RIGHT SIDE (BRAINROT LOGGING)
---------------------------------------------------------------------
local Right = Instance.new("Frame", Main)
Right.Size = UDim2.new(1, -175, 1, -44)
Right.Position = UDim2.new(0, 175, 0, 44)
Right.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local RightCorner = Instance.new("UICorner", Right)
RightCorner.CornerRadius = UDim.new(0, 8)

local BrainLog = Instance.new("TextLabel", Right)
BrainLog.Size = UDim2.new(1, -10, 1, -10)
BrainLog.Position = UDim2.new(0, 5, 0, 5)
BrainLog.Text = "Brainrots logged:\n"
BrainLog.TextColor3 = Color3.fromRGB(255, 255, 255)
BrainLog.BackgroundTransparency = 1
BrainLog.TextXAlignment = Enum.TextXAlignment.Left
BrainLog.TextYAlignment = Enum.TextYAlignment.Top
BrainLog.Font = Enum.Font.Gotham
BrainLog.TextSize = 15
BrainLog.TextWrapped = true


---------------------------------------------------------------------
-- RECEIVE EVENTS
---------------------------------------------------------------------
BrainrotEvent.OnClientEvent:Connect(function(data)
    local name = data.name
    local rarity = data.rarity

    BrainLog.Text = BrainLog.Text .. ("\n• %s  |  %s"):format(name, rarity)
end)


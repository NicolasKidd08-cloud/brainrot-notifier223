--// Brainrot Dev UI Enlarged Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Allowed = { ["Nicolas Kidd"] = true }
if not Allowed[LocalPlayer.Name] then return end

local BrainrotEvent = ReplicatedStorage:WaitForChild("BrainrotLog")

--// MAIN UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "BrainrotDevUI"

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 720, 0, 500)
Main.Position = UDim2.new(0.5, -360, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

--// TOP BAR
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = Color3.fromRGB(10, 35, 70)

Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Top)
Title.Text = "Nicolas's Autojoiner • Discord: discord.gg/yourlink"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 48, 0, 30)
Close.Position = UDim2.new(1, -55, 0.5, -15)
Close.Text = "-"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 26
Close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)

Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local Minimized = false
Close.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Main.Size = UDim2.new(0, 720, 0, 58)
    else
        Main.Size = UDim2.new(0, 720, 0, 500)
    end
end)

-- LINE BELOW TOP
local TopLine = Instance.new("Frame", Main)
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.Position = UDim2.new(0, 0, 0, 58)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 210, 0)

-- LEFT PANEL
local Left = Instance.new("Frame", Main)
Left.Size = UDim2.new(0, 220, 1, -60)
Left.Position = UDim2.new(0, 0, 0, 60)
Left.BackgroundColor3 = Color3.fromRGB(28, 28, 28)

Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 10)

local Separator = Instance.new("Frame", Main)
Separator.Size = UDim2.new(0, 3, 1, -60)
Separator.Position = UDim2.new(0, 220, 0, 60)
Separator.BackgroundColor3 = Color3.fromRGB(255, 210, 0)

local FeatureTitle = Instance.new("TextLabel", Left)
FeatureTitle.Size = UDim2.new(1, 0, 0, 40)
FeatureTitle.Text = "Autojoin Settings"
FeatureTitle.Font = Enum.Font.GothamBold
FeatureTitle.TextSize = 20
FeatureTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FeatureTitle.BackgroundTransparency = 1

-- TOGGLE
local ToggleBack = Instance.new("Frame", Left)
ToggleBack.Size = UDim2.new(0, 58, 0, 30)
ToggleBack.Position = UDim2.new(0, 20, 0, 55)
ToggleBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", ToggleBack).CornerRadius = UDim.new(1, 0)

local ToggleBall = Instance.new("Frame", ToggleBack)
ToggleBall.Size = UDim2.new(0, 26, 0, 26)
ToggleBall.Position = UDim2.new(0, 2, 0, 2)
ToggleBall.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

local ToggleText = Instance.new("TextLabel", Left)
ToggleText.Text = "Auto-Join"
ToggleText.Position = UDim2.new(0, 90, 0, 53)
ToggleText.Size = UDim2.new(0, 120, 0, 30)
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleText.Font = Enum.Font.Gotham
ToggleText.TextSize = 18
ToggleText.BackgroundTransparency = 1

local AutoJoin = false
ToggleBack.InputBegan:Connect(function()
    AutoJoin = not AutoJoin

    if AutoJoin then
        ToggleBack.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
        ToggleBall:TweenPosition(UDim2.new(1, -28, 0, 2), "Out", "Quad", 0.15)
    else
        ToggleBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleBall:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.15)
    end
end)

-- MIN INPUT
local MinLabel = Instance.new("TextLabel", Left)
MinLabel.Size = UDim2.new(1, -30, 0, 26)
MinLabel.Position = UDim2.new(0, 15, 0, 105)
MinLabel.Text = "Minimum per second:"
MinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 17
MinLabel.BackgroundTransparency = 1

local MinBox = Instance.new("TextBox", Left)
MinBox.Size = UDim2.new(1, -30, 0, 38)
MinBox.Position = UDim2.new(0, 15, 0, 135)
MinBox.PlaceholderText = "0"
MinBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 17
Instance.new("UICorner", MinBox).CornerRadius = UDim.new(0, 8)

-- IGNORE LIST
local IgnoreList = Instance.new("TextBox", Left)
IgnoreList.Size = UDim2.new(1, -30, 0, 38)
IgnoreList.Position = UDim2.new(0, 15, 0, 190)
IgnoreList.PlaceholderText = "Search brainrots..."
IgnoreList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IgnoreList.TextColor3 = Color3.fromRGB(255, 255, 255)
IgnoreList.Font = Enum.Font.Gotham
IgnoreList.TextSize = 17
Instance.new("UICorner", IgnoreList).CornerRadius = UDim.new(0, 8)

-- RIGHT PANEL (LOGS)
local Right = Instance.new("Frame", Main)
Right.Size = UDim2.new(1, -225, 1, -60)
Right.Position = UDim2.new(0, 225, 0, 60)
Right.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Right).CornerRadius = UDim.new(0, 10)

local BrainLog = Instance.new("TextLabel", Right)
BrainLog.Size = UDim2.new(1, -14, 1, -14)
BrainLog.Position = UDim2.new(0, 7, 0, 7)
BrainLog.Text = "Brainrots logged:\n"
BrainLog.TextColor3 = Color3.fromRGB(255, 255, 255)
BrainLog.BackgroundTransparency = 1
BrainLog.TextXAlignment = Enum.TextXAlignment.Left
BrainLog.TextYAlignment = Enum.TextYAlignment.Top
BrainLog.Font = Enum.Font.Gotham
BrainLog.TextSize = 18
BrainLog.TextWrapped = true

-- EVENT RECEIVE
BrainrotEvent.OnClientEvent:Connect(function(data)
    BrainLog.Text = BrainLog.Text .. ("\n• %s  |  %s"):format(data.name, data.rarity)
end)

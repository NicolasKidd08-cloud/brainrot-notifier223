-- Brainrot Notifier 223 UI
-- Small button + toggle settings panel

local ScreenGui = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local SettingsFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "BrainrotUI"
ScreenGui.Parent = game.CoreGui

-- MAIN BUTTON (small rectangle)
MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Position = UDim2.new(0.05, 0, 0.35, 0)
MainButton.Size = UDim2.new(0, 120, 0, 40)
MainButton.Text = "Settings"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 18

UICorner:Clone().Parent = MainButton

-- SETTINGS FRAME (hidden by default)
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ScreenGui
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsFrame.Position = UDim2.new(0.05, 0, 0.35, 45)
SettingsFrame.Size = UDim2.new(0, 200, 0, 160)
SettingsFrame.Visible = false

UICorner:Clone().Parent = SettingsFrame

-- Add example setting text
local Label = Instance.new("TextLabel")
Label.Parent = SettingsFrame
Label.BackgroundTransparency = 1
Label.Size = UDim2.new(1, 0, 0, 30)
Label.Position = UDim2.new(0, 0, 0, 10)
Label.Text = "Auto Join: OFF"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.Gotham
Label.TextSize = 16

-- TOGGLE LOGIC
local open = false

MainButton.MouseButton1Click:Connect(function()
	open = not open
	SettingsFrame.Visible = open
end)

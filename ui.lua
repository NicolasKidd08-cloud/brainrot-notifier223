-- UI CREATED FOR YOUR GAME - SAFE VERSION
-- Designer: ChatGPT

local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
ScreenGui.Name = "BrainRotTrackerUI"

-- MAIN FRAME (TOP BAR)
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Brainrot Notifier • Auto-Join"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

local Discord = Instance.new("TextButton", TopBar)
Discord.Size = UDim2.new(0, 200, 1, 0)
Discord.Position = UDim2.new(1, -210, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "Join Discord: discord.gg/Kzzwxg89"
Discord.Font = Enum.Font.GothamMedium
Discord.TextSize = 16
Discord.TextColor3 = Color3.fromRGB(85, 170, 255)

Discord.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/Kzzwxg89")
end)

-- SETTINGS PANEL
local Settings = Instance.new("Frame", ScreenGui)
Settings.Size = UDim2.new(0, 350, 0, 360)
Settings.Position = UDim2.new(0, 20, 0, 60)
Settings.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Settings.Visible = false
Settings.BorderSizePixel = 0

local SettingsTitle = Instance.new("TextLabel", Settings)
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Settings"
SettingsTitle.Font = Enum.Font.GothamSemibold
SettingsTitle.TextSize = 22
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- MONEY MIN/MAX (SLIDERS SIMPLIFIED)
local MinLabel = Instance.new("TextLabel", Settings)
MinLabel.Position = UDim2.new(0, 10, 0, 60)
MinLabel.Size = UDim2.new(1, -20, 0, 30)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Min Money Per Sec:"
MinLabel.TextColor3 = Color3.new(1, 1, 1)
MinLabel.TextSize = 18
MinLabel.Font = Enum.Font.Gotham

local MinBox = Instance.new("TextBox", Settings)
MinBox.Position = UDim2.new(0, 10, 0, 95)
MinBox.Size = UDim2.new(1, -20, 0, 35)
MinBox.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
MinBox.Text = "0"
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 18
MinBox.TextColor3 = Color3.new(1, 1, 1)

local MaxLabel = MinLabel:Clone()
MaxLabel.Parent = Settings
MaxLabel.Position = UDim2.new(0, 10, 0, 140)
MaxLabel.Text = "Max Money Per Sec:"

local MaxBox = MinBox:Clone()
MaxBox.Parent = Settings
MaxBox.Position = UDim2.new(0, 10, 0, 175)
MaxBox.Text = "1000"

-- COLOR PICKER (SIMPLE)
local ColorButton = Instance.new("TextButton", Settings)
ColorButton.Size = UDim2.new(1, -20, 0, 40)
ColorButton.Position = UDim2.new(0, 10, 0, 230)
ColorButton.Text = "Pick UI Color"
ColorButton.Font = Enum.Font.Gotham
ColorButton.TextSize = 18
ColorButton.TextColor3 = Color3.fromRGB(255,255,255)
ColorButton.BackgroundColor3 = Color3.fromRGB(55,55,60)

ColorButton.MouseButton1Click:Connect(function()
    TopBar.BackgroundColor3 = Color3.fromRGB(math.random(40,255), math.random(40,255), math.random(40,255))
end)

-- OPEN SETTINGS BUTTON
local SettingsBtn = Instance.new("TextButton", TopBar)
SettingsBtn.Size = UDim2.new(0, 100, 1, 0)
SettingsBtn.Position = UDim2.new(0, 320, 0, 0)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "⚙ Settings"
SettingsBtn.Font = Enum.Font.GothamMedium
SettingsBtn.TextSize = 18
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

SettingsBtn.MouseButton1Click:Connect(function()
    Settings.Visible = not Settings.Visible
end)




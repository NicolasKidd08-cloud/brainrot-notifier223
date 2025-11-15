-- UI MAIN SCRIPT

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME (small box)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 90)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- UI corner
local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

-- AUTO JOIN BUTTON
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0, 160, 0, 30)
AutoBtn.Position = UDim2.new(0, 10, 0, 10)
AutoBtn.Text = "Auto Join"
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.Parent = Main
Instance.new("UICorner", AutoBtn)

-- SETTINGS BUTTON
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0, 160, 0, 30)
SettingsBtn.Position = UDim2.new(0, 10, 0, 50)
SettingsBtn.Text = "Settings"
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 16
SettingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.Parent = Main
Instance.new("UICorner", SettingsBtn)

-- SETTINGS PANEL
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 180, 0, 120)
SettingsPanel.Position = UDim2.new(0, 0, 1, 5)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SettingsPanel.Parent = Main
Instance.new("UICorner", SettingsPanel)

SettingsPanel.Visible = false

local SettingText = Instance.new("TextLabel")
SettingText.Size = UDim2.new(1, 0, 0, 20)
SettingText.Position = UDim2.new(0, 0, 0, 10)
SettingText.Text = "Settings Panel"
SettingText.Font = Enum.Font.GothamBold
SettingText.TextSize = 14
SettingText.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingText.BackgroundTransparency = 1
SettingText.Parent = SettingsPanel

-- AUTO JOIN LOGIC
local AutoRunning = false

AutoBtn.MouseButton1Click:Connect(function()
    AutoRunning = not AutoRunning
    AutoBtn.Text = AutoRunning and "Auto Join: ON" or "Auto Join"

    if AutoRunning then
        print("Auto Join active")
    else
        print("Auto Join stopped")
    end
end)

-- SETTINGS TOGGLE
SettingsBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)



--[[
    STEAL A BRAINROT – Developer UI
    Style: B
    Color Picker: A
    Animation: Yes
    One-Script Version
]]

-- // SETTINGS
local DISCORD_LINK = "https://discord.gg/Kzzwxg89"
local DEFAULT_COLOR = Color3.fromRGB(85, 170, 255)

-- // SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- // MAIN UI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "BrainrotUI"

-- MAIN FRAME
local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.Size = UDim2.fromOffset(380, 260)
Frame.BackgroundColor3 = DEFAULT_COLOR
Frame.BorderSizePixel = 0
Frame.Active = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- TITLE TEXT
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.fromScale(1, 0.15)
Title.Position = UDim2.fromScale(0, 0)
Title.Text = DISCORD_LINK
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)

-- AUTO JOIN BUTTON
local AutoJoinBtn = Instance.new("TextButton", Frame)
AutoJoinBtn.Size = UDim2.fromScale(0.8, 0.18)
AutoJoinBtn.Position = UDim2.fromScale(0.1, 0.25)
AutoJoinBtn.Text = "Auto Join"
AutoJoinBtn.TextScaled = true
AutoJoinBtn.Font = Enum.Font.GothamSemibold
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoJoinBtn.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", AutoJoinBtn).CornerRadius = UDim.new(0, 8)

-- SETTINGS BUTTON
local SettingsBtn = Instance.new("TextButton", Frame)
SettingsBtn.Size = UDim2.fromScale(0.8, 0.18)
SettingsBtn.Position = UDim2.fromScale(0.1, 0.48)
SettingsBtn.Text = "Settings"
SettingsBtn.TextScaled = true
SettingsBtn.Font = Enum.Font.GothamSemibold
SettingsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 8)

-- // SETTINGS PANEL
local SettingsPanel = Instance.new("Frame", Frame)
SettingsPanel.Size = UDim2.fromScale(1, 0.65)
SettingsPanel.Position = UDim2.fromScale(1, 1.1) -- HIDDEN (slide animation later)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SettingsPanel.BorderSizePixel = 0
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 12)

local SettingsTitle = Instance.new("TextLabel", SettingsPanel)
SettingsTitle.Position = UDim2.fromScale(0, 0)
SettingsTitle.Size = UDim2.fromScale(1, 0.2)
SettingsTitle.Text = "Settings"
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextScaled = true
SettingsTitle.BackgroundTransparency = 1

-- // MIN MONEY INPUT
local MinBox = Instance.new("TextBox", SettingsPanel)
MinBox.Size = UDim2.fromScale(0.8, 0.18)
MinBox.Position = UDim2.fromScale(0.1, 0.25)
MinBox.PlaceholderText = "Minimum Money Per Second"
MinBox.Text = ""
MinBox.TextScaled = true
MinBox.Font = Enum.Font.GothamSemibold
MinBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinBox.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", MinBox).CornerRadius = UDim.new(0, 8)

-- // MAX MONEY INPUT
local MaxBox = Instance.new("TextBox", SettingsPanel)
MaxBox.Size = UDim2.fromScale(0.8, 0.18)
MaxBox.Position = UDim2.fromScale(0.1, 0.48)
MaxBox.PlaceholderText = "Maximum Money Per Second"
MaxBox.Text = ""
MaxBox.TextScaled = true
MaxBox.Font = Enum.Font.GothamSemibold
MaxBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MaxBox.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 8)

-- // COLOR PICKER PRESET BUTTONS
local Colors = {
    {Name = "Blue", Color = Color3.fromRGB(85,170,255)},
    {Name = "Red", Color = Color3.fromRGB(255,85,85)},
    {Name = "Green", Color = Color3.fromRGB(85,255,120)},
    {Name = "Black", Color = Color3.fromRGB(30,30,30)},
}

for i, data in ipairs(Colors) do
    local btn = Instance.new("TextButton", SettingsPanel)
    btn.Size = UDim2.fromScale(0.22, 0.2)
    btn.Position = UDim2.new(0.05 + (i-1)*0.25, 0.72)
    btn.Text = data.Name
    btn.TextScaled = true
    btn.BackgroundColor3 = data.Color
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        Frame.BackgroundColor3 = data.Color
    end)
end

-- // SLIDE ANIMATION FOR SETTINGS
local open = false

local function toggleSettings()
    open = not open

    TweenService:Create(
        SettingsPanel,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = open and UDim2.fromScale(0, 0.35) or UDim2.fromScale(1, 1.1)}
    ):Play()
end

SettingsBtn.MouseButton1Click:Connect(toggleSettings)

-- // AUTO JOIN CLICK
AutoJoinBtn.MouseButton1Click:Connect(function()
    AutoJoinBtn.Text = "Loading..."
    task.wait(1.5)
    AutoJoinBtn.Text = "Auto Join"
end)

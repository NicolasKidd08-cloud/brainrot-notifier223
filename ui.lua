-- ui.lua
-- Robust small UI: two buttons (Auto Join + Settings toggle), animated settings panel, debug prints and notification
-- Paste this into your GitHub ui.lua or into a LocalScript in StarterPlayerScripts.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
if not player then
    warn("ui.lua: This must run as a LocalScript (StarterPlayerScripts).")
    return
end

local PlayerGui = player:WaitForChild("PlayerGui")

-- visible confirmation (safe)
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Brainrot UI",
        Text = "UI script loaded",
        Duration = 3
    })
end)

print("[ui.lua] starting for player:", player.Name)

-- Build UI (parent to PlayerGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotNotifierGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main small panel (rounded)
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.new(0, 180, 0, 44)
main.Position = UDim2.new(0.05, 0, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(36,36,36)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Discord label (small)
local discordLabel = Instance.new("TextLabel")
discordLabel.Parent = main
discordLabel.Size = UDim2.new(0.98, 0, 0, 16)
discordLabel.Position = UDim2.new(0.01, 0, 0, 4)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "https://discord.gg/Kzzwxg89"
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextSize = 12
discordLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
discordLabel.TextXAlignment = Enum.TextXAlignment.Center
discordLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Buttons container
local btnFrame = Instance.new("Frame", main)
btnFrame.Size = UDim2.new(1, -8, 0, 24)
btnFrame.Position = UDim2.new(0, 4, 0, 18)
btnFrame.BackgroundTransparency = 1

-- Auto Join button
local autoBtn = Instance.new("TextButton", btnFrame)
autoBtn.Name = "AutoJoinBtn"
autoBtn.Size = UDim2.new(0.48, 0, 1, 0)
autoBtn.Position = UDim2.new(0, 0, 0, 0)
autoBtn.Text = "Auto Join: OFF"
autoBtn.Font = Enum.Font.GothamSemibold
autoBtn.TextSize = 12
autoBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,6)

-- Settings button
local settingsBtn = Instance.new("TextButton", btnFrame)
settingsBtn.Name = "SettingsBtn"
settingsBtn.Size = UDim2.new(0.48, 0, 1, 0)
settingsBtn.Position = UDim2.new(0.52, 0, 0, 0)
settingsBtn.Text = "Settings"
settingsBtn.Font = Enum.Font.GothamSemibold
settingsBtn.TextSize = 12
settingsBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0,6)

-- Settings panel (hidden by default; positioned under main)
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(0, 220, 0, 120)
settingsPanel.Position = UDim2.new(0, 0, 0, 54) -- will reposition relative to main via container
settingsPanel.BackgroundColor3 = Color3.fromRGB(28,28,28)
settingsPanel.BorderSizePixel = 0
settingsPanel.Parent = screenGui
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0,8)
settingsPanel.Visible = false

-- Keep the settings directly below main visually (compute based on main position)
local function placeSettings()
    local absPos = main.AbsolutePosition
    local x = main.AbsolutePosition.X
    local y = main.AbsolutePosition.Y + main.AbsoluteSize.Y + 6
    settingsPanel.Position = UDim2.new(0, x, 0, y)
end

-- Settings controls
local minLabel = Instance.new("TextLabel", settingsPanel)
minLabel.Size = UDim2.new(0.9, 0, 0, 18)
minLabel.Position = UDim2.new(0.05, 0, 0, 8)
minLabel.BackgroundTransparency = 1
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 12
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.Text = "Min Money / sec"

local minBox = Instance.new("TextBox", settingsPanel)
minBox.Size = UDim2.new(0.9, 0, 0, 28)
minBox.Position = UDim2.new(0.05, 0, 0, 28)
minBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
minBox.Text = ""
minBox.ClearTextOnFocus = false
Instance.new("UICorner", minBox).CornerRadius = UDim.new(0,6)

local maxLabel = Instance.new("TextLabel", settingsPanel)
maxLabel.Size = UDim2.new(0.9, 0, 0, 18)
maxLabel.Position = UDim2.new(0.05, 0, 0, 60)
maxLabel.BackgroundTransparency = 1
maxLabel.Font = Enum.Font.Gotham
maxLabel.TextSize = 12
maxLabel.TextColor3 = Color3.fromRGB(200,200,200)
maxLabel.Text = "Max Money / sec"

local maxBox = Instance.new("TextBox", settingsPanel)
maxBox.Size = UDim2.new(0.9, 0, 0, 28)
maxBox.Position = UDim2.new(0.05, 0, 0, 80)
maxBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
maxBox.Text = ""
maxBox.ClearTextOnFocus = false
Instance.new("UICorner", maxBox).CornerRadius = UDim.new(0,6)

-- Save/Close inside settings
local saveBtn = Instance.new("TextButton", settingsPanel)
saveBtn.Size = UDim2.new(0.9, 0, 0, 26)
saveBtn.Position = UDim2.new(0.05, 0, 0, 108 - 30)
saveBtn.Text = "Save & Close"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.BackgroundColor3 = Color3.fromRGB(75,130,220)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,6)

-- simple state
local autoOn = false
local minMoney = 0
local maxMoney = 999999

-- Debug prints to Output
print("[ui.lua] UI created; waiting for interactions.")

-- Settings toggle behavior (Settings button toggles open/close)
local settingsOpen = false
local animTime = 0.28
local settingsTweenInfo = TweenInfo.new(animTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openSettings()
    if settingsOpen then return end
    placeSettings()
    settingsPanel.Visible = true
    settingsPanel.Position = UDim2.new(0, main.AbsolutePosition.X, 0, main.AbsolutePosition.Y + main.AbsoluteSize.Y + 10)
    settingsPanel.AnchorPoint = Vector2.new(0,0)
    settingsPanel.Size = UDim2.new(0, main.AbsoluteSize.X + 40, 0, 120)
    settingsPanel.BackgroundTransparency = 1
    TweenService:Create(settingsPanel, settingsTweenInfo, {BackgroundTransparency = 0}):Play()
    settingsOpen = true
    print("[ui.lua] settings opened")
end

local function closeSettings()
    if not settingsOpen then return end
    TweenService:Create(settingsPanel, settingsTweenInfo, {BackgroundTransparency = 1}):Play()
    delay(animTime, function()
        settingsPanel.Visible = false
    end)
    settingsOpen = false
    print("[ui.lua] settings closed")
end

settingsBtn.MouseButton1Click:Connect(function()
    if settingsOpen then
        closeSettings()
    else
        openSettings()
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local mn = tonumber(minBox.Text)
    local mx = tonumber(maxBox.Text)
    if mn then minMoney = mn end
    if mx then maxMoney = mx end
    print(string.format("[ui.lua] saved settings min=%s max=%s", tostring(minMoney), tostring(maxMoney)))
    closeSettings()
end)

-- Auto join toggle
autoBtn.MouseButton1Click:Connect(function()
    autoOn = not autoOn
    autoBtn.Text = autoOn and "Auto Join: ON" or "Auto Join: OFF"
    print("[ui.lua] Auto join toggled:", autoOn)
end)

-- Simulated search loop (debug)
task.spawn(function()
    while true do
        task.wait(1)
        if autoOn then
            -- This is ONLY a simulated indicator. Do not add exploit code here.
            print(string.format("[ui.lua] searching (min=%d max=%d)...", minMoney, maxMoney))
        end
    end
end)

-- reposition settings if screen resizes
main:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeSettings)
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeSettings)


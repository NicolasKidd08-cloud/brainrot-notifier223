-- Lumora-style Top Bar UI (Safe, single-script)
-- Paste into StarterPlayer > StarterPlayerScripts as a LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local DISCORD_LINK = "https://discord.gg/Kzzwxg89"
local UI_NAME = "LumoraTopUI"
local DEFAULT_THEME = Color3.fromRGB(34,34,40)

-- Optional telemetry RemoteEvent (server may create or listen)
local REMOTE_NAME = "LumoraAutoJoinRequest"
local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
    -- create (server can also create it). This is safe; it just exists.
    remote = Instance.new("RemoteEvent")
    remote.Name = REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

-- Utilities
local function setAttr(name, value) -- keep simple persistence through attributes (survives respawn)
    if player:GetAttribute(name) ~= value then
        player:SetAttribute(name, value)
    end
end
local function getAttr(name, fallback)
    local v = player:GetAttribute(name)
    if v == nil then return fallback end
    return v
end

-- Default stored settings (if not present)
if getAttr("Lumora.MinPerSec", nil) == nil then setAttr("Lumora.MinPerSec", 0) end
if getAttr("Lumora.MaxPerSec", nil) == nil then setAttr("Lumora.MaxPerSec", 999) end
if getAttr("Lumora.ThemeR", nil) == nil then
    setAttr("Lumora.ThemeR", DEFAULT_THEME.R)
    setAttr("Lumora.ThemeG", DEFAULT_THEME.G)
    setAttr("Lumora.ThemeB", DEFAULT_THEME.B)
end
if getAttr("Lumora.AutoJoin", nil) == nil then setAttr("Lumora.AutoJoin", false) end

-- Create or reuse ScreenGui (so GUI doesn't duplicate if script runs again)
local screenGui = playerGui:FindFirstChild(UI_NAME)
if screenGui and screenGui:IsA("ScreenGui") then
    -- reuse existing: ensure ResetOnSpawn and name
    screenGui.ResetOnSpawn = false
else
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = UI_NAME
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false -- keeps UI after death
    screenGui.IgnoreGuiInset = false
end

-- Remove any old content inside to prevent duplication on re-run (but keep the same ScreenGui)
for _, child in ipairs(screenGui:GetChildren()) do
    child:Destroy()
end

-- theme color getter
local function themeColor()
    return Color3.new(getAttr("Lumora.ThemeR", DEFAULT_THEME.R),
                      getAttr("Lumora.ThemeG", DEFAULT_THEME.G),
                      getAttr("Lumora.ThemeB", DEFAULT_THEME.B))
end

-- ======= TOP BAR =======
local Bar = Instance.new("Frame")
Bar.Name = "TopBar"
Bar.Size = UDim2.new(1, 0, 0, 64)
Bar.Position = UDim2.new(0, 0, 0, 0)
Bar.BackgroundColor3 = themeColor()
Bar.BorderSizePixel = 0
Bar.Parent = screenGui
local barCorner = Instance.new("UICorner", Bar)
barCorner.CornerRadius = UDim.new(0, 8)

-- Left: Auto Join
local AutoBtn = Instance.new("TextButton")
AutoBtn.Name = "AutoJoinBtn"
AutoBtn.Parent = Bar
AutoBtn.Size = UDim2.new(0, 150, 0, 44)
AutoBtn.Position = UDim2.new(0, 12, 0, 10)
AutoBtn.BackgroundColor3 = Color3.fromRGB(40,40,45)
AutoBtn.BorderSizePixel = 0
AutoBtn.Font = Enum.Font.GothamSemibold
AutoBtn.TextSize = 18
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.Text = "Auto Join: OFF"
AutoBtn.AutoButtonColor = true
local autoCorner = Instance.new("UICorner", AutoBtn)
autoCorner.CornerRadius = UDim.new(0,8)

-- Center: big Discord link
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Parent = Bar
DiscordBtn.Size = UDim2.new(0, 540, 0, 64)
DiscordBtn.AnchorPoint = Vector2.new(0.5, 0)
DiscordBtn.Position = UDim2.new(0.5, 0, 0, 0)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 22
DiscordBtn.TextColor3 = Color3.fromRGB(200,220,255)
DiscordBtn.Text = "JOIN DISCORD: " .. DISCORD_LINK
DiscordBtn.TextWrapped = true

-- Right: Settings button
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.Parent = Bar
SettingsBtn.Size = UDim2.new(0, 120, 0, 44)
SettingsBtn.Position = UDim2.new(1, -132, 0, 10)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(40,40,45)
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Font = Enum.Font.GothamSemibold
SettingsBtn.TextSize = 18
SettingsBtn.TextColor3 = Color3.fromRGB(255,255,255)
SettingsBtn.Text = "Settings"
local setCorner = Instance.new("UICorner", SettingsBtn)
setCorner.CornerRadius = UDim.new(0,8)

-- Small status label near AutoBtn (right of auto button)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = Bar
StatusLabel.Size = UDim2.new(0, 240, 0, 28)
StatusLabel.Position = UDim2.new(0, 170, 0, 18)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(220,220,220)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Click Discord copies to clipboard (Studio & supported envs)
DiscordBtn.MouseButton1Click:Connect(function()
    -- try setclipboard; if not available, show a toast
    local ok, err = pcall(function() setclipboard(DISCORD_LINK) end)
    if ok then
        StatusLabel.Text = "Status: Discord link copied!"
        delay(2, function() StatusLabel.Text = "Status: Idle" end)
    else
        StatusLabel.Text = "Status: Unable to copy link (use Ctrl+C)"
        delay(2, function() StatusLabel.Text = "Status: Idle" end)
    end
end)

-- ======= SETTINGS PANEL (sliding) =======
local Panel = Instance.new("Frame")
Panel.Name = "SettingsPanel"
Panel.Parent = screenGui
Panel.Size = UDim2.new(0, 540, 0, 300)
Panel.Position = UDim2.new(0.5, -270, 0, -360) -- hidden above screen initially
Panel.AnchorPoint = Vector2.new(0.5, 0)
Panel.BackgroundColor3 = Color3.fromRGB(28,28,34)
Panel.BorderSizePixel = 0
local panelCorner = Instance.new("UICorner", Panel)
panelCorner.CornerRadius = UDim.new(0, 12)

-- Panel header
local PTitle = Instance.new("TextLabel", Panel)
PTitle.Size = UDim2.new(1, -24, 0, 38)
PTitle.Position = UDim2.new(0, 12, 0, 12)
PTitle.BackgroundTransparency = 1
PTitle.Font = Enum.Font.GothamBold
PTitle.TextSize = 20
PTitle.TextColor3 = Color3.fromRGB(240,240,240)
PTitle.Text = "Lumora Priority — Settings"

-- Close button
local CloseBtn = Instance.new("TextButton", Panel)
CloseBtn.Size = UDim2.new(0,32,0,28)
CloseBtn.Position = UDim2.new(1, -44, 0, 12)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(0,6)

-- Min/Max UI boxes
local labelMin = Instance.new("TextLabel", Panel)
labelMin.Position = UDim2.new(0, 24, 0, 70)
labelMin.Size = UDim2.new(0, 220, 0, 22)
labelMin.BackgroundTransparency = 1
labelMin.Font = Enum.Font.Gotham
labelMin.TextSize = 16
labelMin.TextColor3 = Color3.fromRGB(210,210,210)
labelMin.Text = "Min Money / sec"

local minBox = Instance.new("TextBox", Panel)
minBox.Position = UDim2.new(0, 24, 0, 98)
minBox.Size = UDim2.new(0, 180, 0, 34)
minBox.BackgroundColor3 = Color3.fromRGB(44,44,48)
minBox.TextColor3 = Color3.fromRGB(240,240,240)
minBox.Text = tostring(getAttr("Lumora.MinPerSec", 0))
minBox.Font = Enum.Font.Gotham
minBox.TextSize = 16
local minCorner = Instance.new("UICorner", minBox)
minCorner.CornerRadius = UDim.new(0, 6)

local labelMax = labelMin:Clone()
labelMax.Parent = Panel
labelMax.Position = UDim2.new(0, 240, 0, 70)
labelMax.Text = "Max Money / sec"

local maxBox = minBox:Clone()
maxBox.Parent = Panel
maxBox.Position = UDim2.new(0, 240, 0, 98)
maxBox.Text = tostring(getAttr("Lumora.MaxPerSec", 999))

-- Color presets (small swatches)
local swatches = {
    Color3.fromRGB(34,34,40),
    Color3.fromRGB(40,120,255),
    Color3.fromRGB(80,200,140),
    Color3.fromRGB(180,80,220),
    Color3.fromRGB(70,70,70),
}
local swStartX = 24
for i, col in ipairs(swatches) do
    local sw = Instance.new("TextButton", Panel)
    sw.Size = UDim2.new(0, 46, 0, 32)
    sw.Position = UDim2.new(0, swStartX + (i-1) * 58, 0, 150)
    sw.BackgroundColor3 = col
    sw.Text = ""
    sw.BorderSizePixel = 0
    local c = Instance.new("UICorner", sw); c.CornerRadius = UDim.new(0,6)
    sw.MouseButton1Click:Connect(function()
        -- apply theme and save
        Bar.BackgroundColor3 = col
        setAttr("Lumora.ThemeR", col.R)
        setAttr("Lumora.ThemeG", col.G)
        setAttr("Lumora.ThemeB", col.B)
    end)
end

-- Save button
local SaveBtn = Instance.new("TextButton", Panel)
SaveBtn.Size = UDim2.new(0, 160, 0, 36)
SaveBtn.Position = UDim2.new(1, -176, 1, -56)
SaveBtn.AnchorPoint = Vector2.new(0, 0)
SaveBtn.Text = "Save"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 16
SaveBtn.TextColor3 = Color3.fromRGB(255,255,255)
SaveBtn.BackgroundColor3 = Color3.fromRGB(55,125,90)
local saveCorner = Instance.new("UICorner", SaveBtn); saveCorner.CornerRadius = UDim.new(0,6)

-- Small helper: animate panel in/out
local panelOpen = false
local panelTweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function openPanel()
    if panelOpen then return end
    panelOpen = true
    Panel.Visible = true
    TweenService:Create(Panel, panelTweenInfo, {Position = UDim2.new(0.5, -270, 0, 74)}):Play()
end
local function closePanel()
    if not panelOpen then return end
    panelOpen = false
    TweenService:Create(Panel, panelTweenInfo, {Position = UDim2.new(0.5, -270, 0, -360)}):Play()
    delay(0.36, function()
        if not panelOpen then Panel.Visible = false end
    end)
end

SettingsBtn.MouseButton1Click:Connect(function()
    if panelOpen then closePanel() else openPanel() end
end)
CloseBtn.MouseButton1Click:Connect(closePanel)

-- Save behavior
SaveBtn.MouseButton1Click:Connect(function()
    local minN = tonumber(minBox.Text) or 0
    local maxN = tonumber(maxBox.Text) or 0
    if minN < 0 then minN = 0 end
    if maxN < 0 then maxN = 0 end
    if minN > maxN then minN, maxN = maxN, minN end
    setAttr("Lumora.MinPerSec", minN)
    setAttr("Lumora.MaxPerSec", maxN)
    StatusLabel.Text = ("Status: Saved (min=%d max=%d)"):format(minN, maxN)
    delay(2, function() StatusLabel.Text = "Status: Idle" end)
    closePanel()
end)

-- ======= Auto Join toggle behavior (SIMULATED & SAFE) =======
local function applyAutoState(enabled)
    setAttr("Lumora.AutoJoin", enabled)
    if enabled then
        AutoBtn.Text = "Auto Join: WORKING"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
        StatusLabel.Text = "Status: Auto-join searching..."
        -- Optionally fire to server (safe telemetry/log)
        pcall(function()
            remote:FireServer({
                player = player.Name,
                action = "start_auto",
                min = tonumber(getAttr("Lumora.MinPerSec", 0)),
                max = tonumber(getAttr("Lumora.MaxPerSec", 999)),
                timestamp = os.time()
            })
        end)
    else
        AutoBtn.Text = "Auto Join: OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        StatusLabel.Text = "Status: Idle"
        pcall(function()
            remote:FireServer({
                player = player.Name,
                action = "stop_auto",
                timestamp = os.time()
            })
        end)
    end
end

-- Initialize from stored attribute
applyAutoState(getAttr("Lumora.AutoJoin", false))

AutoBtn.MouseButton1Click:Connect(function()
    local newState = not getAttr("Lumora.AutoJoin", false)
    applyAutoState(newState)
end)

-- Ensure theme is applied from stored attributes on load
Bar.BackgroundColor3 = themeColor()

-- Make GUI persist visually after death (ScreenGui.ResetOnSpawn already set false)
-- But the LocalScript restarts on respawn, so re-apply stored state when this script runs.
-- We already read attributes at top and applied states/theme.

-- Small safety: update displayed textboxes from attributes when reloaded
minBox.Text = tostring(getAttr("Lumora.MinPerSec", 0))
maxBox.Text = tostring(getAttr("Lumora.MaxPerSec", 999))

-- Optional: small hint if local player dies and UI was hidden by something, re-show
player.CharacterAdded:Connect(function()
    -- re-apply theme & auto state
    Bar.BackgroundColor3 = themeColor()
    applyAutoState(getAttr("Lumora.AutoJoin", false))
end)

-- Finished loading UI
StatusLabel.Text = "Status: Ready"
delay(2, function() StatusLabel.Text = "Status: Idle" end)

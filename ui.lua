-- Brainrot Notifier UI (Safe Developer Version)

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotTopUI"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false -- 🔥 KEEP UI ON DEATH

--============ TOP BAR ============--

local Bar = Instance.new("Frame")
Bar.Parent = ScreenGui
Bar.Size = UDim2.new(1, 0, 0, 60)
Bar.Position = UDim2.new(0, 0, 0, 0)
Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Bar.BorderSizePixel = 0

--============ CENTER DISCORD ============--

local DiscordBig = Instance.new("TextButton")
DiscordBig.Parent = Bar
DiscordBig.Size = UDim2.new(0, 420, 1, 0)
DiscordBig.Position = UDim2.new(0.5, -210, 0, 0) -- CENTERED
DiscordBig.BackgroundTransparency = 1
DiscordBig.Font = Enum.Font.GothamBold
DiscordBig.TextSize = 26
DiscordBig.TextColor3 = Color3.fromRGB(90, 170, 255)
DiscordBig.Text = "JOIN DISCORD: discord.gg/Kzzwxg89"

DiscordBig.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/Kzzwxg89")
end)

--============ AUTO JOIN BUTTON ============--

local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Parent = Bar
AutoJoinBtn.Size = UDim2.new(0, 130, 0, 50)
AutoJoinBtn.Position = UDim2.new(0, 20, 0.08, 0)
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AutoJoinBtn.TextColor3 = Color3.white
AutoJoinBtn.Font = Enum.Font.GothamSemibold
AutoJoinBtn.TextSize = 20
AutoJoinBtn.Text = "Auto Join: OFF"

local auto = false
AutoJoinBtn.MouseButton1Click:Connect(function()
	auto = not auto
	if auto then
		AutoJoinBtn.Text = "Auto Join: WORKING"
		AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
	else
		AutoJoinBtn.Text = "Auto Join: OFF"
		AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)

--============ SETTINGS BUTTON ============--

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Parent = Bar
SettingsBtn.Size = UDim2.new(0, 130, 0, 50)
SettingsBtn.Position = UDim2.new(1, -150, 0.08, 0)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsBtn.TextColor3 = Color3.white
SettingsBtn.Font = Enum.Font.GothamSemibold
SettingsBtn.TextSize = 20
SettingsBtn.Text = "Settings"

--============ SETTINGS PANEL ============--

local Panel = Instance.new("Frame")
Panel.Parent = ScreenGui
Panel.Visible = false
Panel.Size = UDim2.new(0, 360, 0, 380)
Panel.Position = UDim2.new(0, 20, 0, 70)
Panel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Panel.BorderSizePixel = 0

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Parent = Panel
PanelTitle.Size = UDim2.new(1, 0, 0, 40)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "Settings"
PanelTitle.Font = Enum.Font.GothamSemibold
PanelTitle.TextSize = 24
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- MIN MONEY
local MinLabel = Instance.new("TextLabel")
MinLabel.Parent = Panel
MinLabel.Position = UDim2.new(0, 10, 0, 60)
MinLabel.Size = UDim2.new(1, -20, 0, 25)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Minimum Money/sec:"
MinLabel.TextColor3 = Color3.white
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 18

local MinBox = Instance.new("TextBox")
MinBox.Parent = Panel
MinBox.Position = UDim2.new(0, 10, 0, 90)
MinBox.Size = UDim2.new(1, -20, 0, 40)
MinBox.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBox.Text = "0"
MinBox.TextColor3 = Color3.white
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 18

-- MAX MONEY
local MaxLabel = MinLabel:Clone()
MaxLabel.Parent = Panel
MaxLabel.Position = UDim2.new(0, 10, 0, 145)
MaxLabel.Text = "Maximum Money/sec:"

local MaxBox = MinBox:Clone()
MaxBox.Parent = Panel
MaxBox.Position = UDim2.new(0, 10, 0, 175)
MaxBox.Text = "999"

-- COLOR PICKER (simple random)
local ColorBtn = Instance.new("TextButton")
ColorBtn.Parent = Panel
ColorBtn.Size = UDim2.new(1, -20, 0, 45)
ColorBtn.Position = UDim2.new(0, 10, 0, 240)
ColorBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
ColorBtn.Text = "Randomize UI Color"
ColorBtn.TextSize = 18
ColorBtn.Font = Enum.Font.Gotham
ColorBtn.TextColor3 = Color3.white

ColorBtn.MouseButton1Click:Connect(function()
	local r = math.random(50, 180)
	local g = math.random(50, 180)
	local b = math.random(50, 180)
	Bar.BackgroundColor3 = Color3.fromRGB(r, g, b)
end)

-- SETTINGS TOGGLE
SettingsBtn.MouseButton1Click:Connect(function()
	Panel.Visible = not Panel.Visible
end)

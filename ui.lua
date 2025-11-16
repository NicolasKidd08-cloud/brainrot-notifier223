-- Brainrot Notifier UI (Safe Developer Version)

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotTopUI"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

--============ TOP BAR ============--

local Bar = Instance.new("Frame")
Bar.Parent = ScreenGui
Bar.Size = UDim2.new(1, 0, 0, 48)
Bar.Position = UDim2.new(0, 0, 0, 0)
Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Bar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Bar
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 22
Title.Text = "Brainrot Notifier • Auto Filter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

--============ DISCORD BUTTON ============--

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Parent = Bar
DiscordBtn.Size = UDim2.new(0, 240, 1, 0)
DiscordBtn.Position = UDim2.new(1, -250, 0, 0)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.TextSize = 18
DiscordBtn.TextColor3 = Color3.fromRGB(90, 170, 255)
DiscordBtn.Text = "discord.gg/Kzzwxg89"

DiscordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/Kzzwxg89")
end)

--============ SETTINGS BUTTON ============--

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Parent = Bar
SettingsBtn.Size = UDim2.new(0, 120, 1, 0)
SettingsBtn.Position = UDim2.new(0, 380, 0, 0)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Font = Enum.Font.Gotham
SettingsBtn.TextSize = 18
SettingsBtn.Text = "⚙ Settings"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

--============ SETTINGS PANEL ============--

local Panel = Instance.new("Frame")
Panel.Parent = ScreenGui
Panel.Visible = false
Panel.Size = UDim2.new(0, 350, 0, 350)
Panel.Position = UDim2.new(0, 20, 0, 60)
Panel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Panel.BorderSizePixel = 0

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Parent = Panel
PanelTitle.Size = UDim2.new(1, 0, 0, 40)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "Settings"
PanelTitle.Font = Enum.Font.GothamSemibold
PanelTitle.TextSize = 22
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
MinBox.Size = UDim2.new(1, -20, 0, 35)
MinBox.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBox.Text = "0"
MinBox.TextColor3 = Color3.white
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 18

-- MAX MONEY
local MaxLabel = MinLabel:Clone()
MaxLabel.Parent = Panel
MaxLabel.Position = UDim2.new(0, 10, 0, 140)
MaxLabel.Text = "Maximum Money/sec:"

local MaxBox = MinBox:Clone()
MaxBox.Parent = Panel
MaxBox.Position = UDim2.new(0, 10, 0, 170)
MaxBox.Text = "999"

-- COLOR PICKER (simple randomizer)
local ColorBtn = Instance.new("TextButton")
ColorBtn.Parent = Panel
ColorBtn.Size = UDim2.new(1, -20, 0, 45)
ColorBtn.Position = UDim2.new(0, 10, 0, 230)
ColorBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
ColorBtn.Text = "Randomize UI Color"
ColorBtn.TextSize = 18
ColorBtn.Font = Enum.Font.Gotham
ColorBtn.TextColor3 = Color3.white

ColorBtn.MouseButton1Click:Connect(function()
	local r = math.random(40, 200)
	local g = math.random(40, 200)
	local b = math.random(40, 200)
	Bar.BackgroundColor3 = Color3.fromRGB(r, g, b)
end)

-- Toggle Panel
SettingsBtn.MouseButton1Click:Connect(function()
	Panel.Visible = not Panel.Visible
end)

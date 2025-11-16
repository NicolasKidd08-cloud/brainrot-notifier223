--// Nick & Scrap’s Auto Jointer UI (UPDATED WITH OPEN/CLOSE + TITLES + FIXED SPACING)

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-----------------------------------------------------------
-- MAIN FRAME WITH RAINBOW OUTLINE
-----------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 750, 0, 420)
MainFrame.Position = UDim2.new(0.5, -375, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 33)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 3

task.spawn(function()
	while true do
		for i = 0, 255 do
			Border.Color = Color3.fromHSV(i/255, 1, 1)
			task.wait(0.02)
		end
	end
end)

-----------------------------------------------------------
-- HEADER (ALWAYS VISIBLE)
-----------------------------------------------------------
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap’s Auto Jointer"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(150, 255, 150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Discord link moved further right
local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0, 240, 1, 0)
Discord.Position = UDim2.new(1, -280, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Font = Enum.Font.GothamBold
Discord.TextScaled = true
Discord.TextColor3 = Color3.fromRGB(120, 200, 255)
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/pAgSFBKj")
	Discord.Text = "Copied!"
	task.wait(1.2)
	Discord.Text = "discord.gg/pAgSFBKj"
end)

-- Red open / close button
local ToggleUI = Instance.new("TextButton")
ToggleUI.Size = UDim2.new(0, 35, 0, 35)
ToggleUI.Position = UDim2.new(1, -45, 0.5, -17)
ToggleUI.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
ToggleUI.Text = ""
ToggleUI.Parent = Header

local ToggleCorner = Instance.new("UICorner", ToggleUI)
ToggleCorner.CornerRadius = UDim.new(1, 0)

local UIVisible = true

ToggleUI.MouseButton1Click:Connect(function()
	UIVisible = not UIVisible
	for _, v in ipairs(MainFrame:GetChildren()) do
		if v ~= Header then
			v.Visible = UIVisible
		end
	end
end)

-----------------------------------------------------------
-- LEFT SIDEBAR
-----------------------------------------------------------
local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 200, 1, -50)
Side.Position = UDim2.new(0, 0, 0, 50)
Side.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
Side.Parent = MainFrame

local SideCorner = Instance.new("UICorner", Side)

-- FEATURES TITLE (you asked for this)
local FeaturesTitle = Instance.new("TextLabel")
FeaturesTitle.Size = UDim2.new(1, 0, 0, 35)
FeaturesTitle.BackgroundTransparency = 1
FeaturesTitle.Text = "Features"
FeaturesTitle.Font = Enum.Font.GothamBold
FeaturesTitle.TextScaled = true
FeaturesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FeaturesTitle.Parent = Side

-----------------------------------------------------------
-- BUTTON MAKER
-----------------------------------------------------------
local function MakeButton(name, y)
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1, -30, 0, 50)
	B.Position = UDim2.new(0, 15, 0, y)
	B.BackgroundColor3 = Color3.fromRGB(50, 55, 60)
	B.TextColor3 = Color3.fromRGB(255, 255, 255)
	B.TextScaled = true
	B.Font = Enum.Font.GothamBold
	B.Text = name
	B.Parent = Side

	local C = Instance.new("UICorner", B)

	return B
end

-----------------------------------------------------------
-- AUTO JOIN BUTTON
-----------------------------------------------------------
local AutoJoinEnabled = false
local AutoJoinBtn = MakeButton("Auto Join", 50)

AutoJoinBtn.MouseButton1Click:Connect(function()
	AutoJoinEnabled = not AutoJoinEnabled
	AutoJoinBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
end)

-----------------------------------------------------------
-- PERSISTENT REJOIN BUTTON
-----------------------------------------------------------
local PersistentEnabled = false
local Persistent = MakeButton("Persistent Rejoin", 110)

Persistent.MouseButton1Click:Connect(function()
	PersistentEnabled = not PersistentEnabled
	Persistent.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-----------------------------------------------------------
-- MINIMUM INPUT
-----------------------------------------------------------
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(1, -30, 0, 25)
MinLabel.Position = UDim2.new(0, 15, 0, 175)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Minimum/sec (MS) (Millions)"
MinLabel.Font = Enum.Font.GothamMedium
MinLabel.TextScaled = true
MinLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
MinLabel.Parent = Side

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -30, 0, 40)
Input.Position = UDim2.new(0, 15, 0, 210)
Input.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Input.Text = "10"
Input.TextScaled = true
Input.Font = Enum.Font.GothamBold
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Parent = Side

local InputCorner = Instance.new("UICorner", Input)

-----------------------------------------------------------
-- STATUS LABEL
-----------------------------------------------------------
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 30)
Status.Position = UDim2.new(0, 15, 1, -40)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.Font = Enum.Font.GothamMedium
Status.TextScaled = true
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Parent = Side

-----------------------------------------------------------
-- RIGHT PANEL (LOGS)
-----------------------------------------------------------
local Right = Instance.new("Frame")
Right.Size = UDim2.new(1, -200, 1, -50)
Right.Position = UDim2.new(0, 200, 0, 50)
Right.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
Right.Parent = MainFrame

local RightCorner = Instance.new("UICorner", Right)

-- TITLE ABOVE LOGS (you asked for this)
local LogsTitle = Instance.new("TextLabel")
LogsTitle.Size = UDim2.new(1, 0, 0, 40)
LogsTitle.BackgroundTransparency = 1
LogsTitle.Text = "Server Logs & Join List"
LogsTitle.Font = Enum.Font.GothamBold
LogsTitle.TextScaled = true
LogsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LogsTitle.Parent = Right

-- LOG BOX
local LogBox = Instance.new("TextLabel")
LogBox.Size = UDim2.new(1, -30, 1, -60)
LogBox.Position = UDim2.new(0, 15, 0, 45)
LogBox.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
LogBox.TextColor3 = Color3.fromRGB(200, 200, 220)
LogBox.Font = Enum.Font.Code
LogBox.TextSize = 18
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.Text = "[AJ] Auto Join cycle ready.\n[FEATURE] Persistent Rejoin is OFF."
LogBox.Parent = Right

local LogCorner = Instance.new("UICorner", LogBox)

-----------------------------------------------------------
-- LOG FUNCTION
-----------------------------------------------------------
function AddLog(t)
	LogBox.Text = LogBox.Text .. "\n" .. t
end

-----------------------------------------------------------
-- UPDATE STATUS CONSTANTLY
-----------------------------------------------------------
task.spawn(function()
	while true do
		Status.Text = AutoJoinEnabled and "Status: Working..." or "Status: Idle"
		task.wait(0.2)
	end
end)

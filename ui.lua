-- Nick & Scrap’s Auto Jointer UI (OPEN/CLOSE WORKING + TITLES)
-- UI-only, safe. Place in StarterPlayerScripts or StarterGui as a LocalScript.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Remove older GUI if present
local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

-- CONFIG
local FULL_SIZE = UDim2.new(0, 750, 0, 420)
local HEADER_HEIGHT = 55
local CLOSED_SIZE = UDim2.new(0, 750, 0, HEADER_HEIGHT)

-- MAIN SCREENGUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0.5, -375, 0.2, 0)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 33)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)
local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 3

-- Rainbow border effect (lightweight)
task.spawn(function()
	while true do
		for i = 0, 255 do
			Border.Color = Color3.fromHSV(i/255, 1, 1)
			task.wait(0.02)
		end
	end
end)

-- HEADER (always visible)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Title (left)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 360, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(150, 255, 150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Discord button (moved more to the right)
local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0, 260, 1, 0)
Discord.Position = UDim2.new(1, -310, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Font = Enum.Font.GothamBold
Discord.TextScaled = true
Discord.TextColor3 = Color3.fromRGB(120, 200, 255)
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
	-- copies to clipboard (works in Roblox Studio + some environments)
	if setclipboard then
		setclipboard("https://discord.gg/pAgSFBKj")
	end
	Discord.Text = "Copied!"
	task.wait(1)
	Discord.Text = "discord.gg/pAgSFBKj"
end)

-- Red open/close button (right)
local ToggleUI = Instance.new("TextButton")
ToggleUI.Size = UDim2.new(0, 36, 0, 36)
ToggleUI.Position = UDim2.new(1, -40, 0.5, -18)
ToggleUI.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ToggleUI.Text = ""
ToggleUI.Parent = Header

local ToggleCorner = Instance.new("UICorner", ToggleUI)
ToggleCorner.CornerRadius = UDim.new(1, 0)

-- CONTENT FRAME (contains side + right). We'll show/hide or tween main frame size.
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT)
Content.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- LEFT SIDEBAR
local Side = Instance.new("Frame")
Side.Name = "Side"
Side.Size = UDim2.new(0, 200, 1, 0)
Side.Position = UDim2.new(0, 0, 0, 0)
Side.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
Side.Parent = Content

local SideCorner = Instance.new("UICorner", Side)
SideCorner.CornerRadius = UDim.new(0, 12)

-- "Features" title above the buttons (per your request)
local FeaturesTitle = Instance.new("TextLabel")
FeaturesTitle.Name = "FeaturesTitle"
FeaturesTitle.Size = UDim2.new(1, 0, 0, 36)
FeaturesTitle.Position = UDim2.new(0, 0, 0, 8)
FeaturesTitle.BackgroundTransparency = 1
FeaturesTitle.Text = "Features"
FeaturesTitle.Font = Enum.Font.GothamBold
FeaturesTitle.TextScaled = true
FeaturesTitle.TextColor3 = Color3.fromRGB(255,255,255)
FeaturesTitle.Parent = Side

-- Buttons container to offset under title
local ButtonsHolder = Instance.new("Frame")
ButtonsHolder.Size = UDim2.new(1, 0, 1, -120)
ButtonsHolder.Position = UDim2.new(0, 0, 0, 52)
ButtonsHolder.BackgroundTransparency = 1
ButtonsHolder.Parent = Side

-- Helper to make buttons
local function MakeButton(parent, labelText, top)
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1, -30, 0, 46)
	B.Position = UDim2.new(0, 15, 0, top)
	B.BackgroundColor3 = Color3.fromRGB(50, 55, 60)
	B.TextColor3 = Color3.fromRGB(255,255,255)
	B.Text = labelText
	B.Font = Enum.Font.GothamBold
	B.TextScaled = true
	B.Parent = parent
	local c = Instance.new("UICorner", B)
	c.CornerRadius = UDim.new(0, 8)
	return B
end

-- AutoJoin toggle
local AutoJoinEnabled = false
local AutoJoinBtn = MakeButton(ButtonsHolder, "Auto Join", 6)
AutoJoinBtn.MouseButton1Click:Connect(function()
	AutoJoinEnabled = not AutoJoinEnabled
	AutoJoinBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
end)

-- Persistent Rejoin toggle
local PersistentEnabled = false
local PersistentBtn = MakeButton(ButtonsHolder, "Persistent Rejoin", 64)
PersistentBtn.MouseButton1Click:Connect(function()
	PersistentEnabled = not PersistentEnabled
	PersistentBtn.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-- Minimum input label + box
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(1, -30, 0, 24)
MinLabel.Position = UDim2.new(0, 15, 0, 130)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Minimum/sec (MS) (Millions)"
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextScaled = true
MinLabel.TextColor3 = Color3.fromRGB(200,200,200)
MinLabel.Parent = Side

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -30, 0, 40)
InputBox.Position = UDim2.new(0, 15, 0, 160)
InputBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
InputBox.Text = "10"
InputBox.Font = Enum.Font.GothamBold
InputBox.TextScaled = true
InputBox.TextColor3 = Color3.fromRGB(255,255,255)
InputBox.Parent = Side
local inputCorner = Instance.new("UICorner", InputBox)
inputCorner.CornerRadius = UDim.new(0, 8)

-- Status label bottom-left
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 20)
Status.Position = UDim2.new(0, 15, 1, -34)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.Font = Enum.Font.Gotham
Status.TextScaled = true
Status.TextColor3 = Color3.fromRGB(160,160,160)
Status.Parent = Side

-- RIGHT PANEL (Logs)
local Right = Instance.new("Frame")
Right.Name = "Right"
Right.Size = UDim2.new(1, -200, 1, 0)
Right.Position = UDim2.new(0, 200, 0, 0)
Right.BackgroundColor3 = Color3.fromRGB(30,30,34)
Right.Parent = Content

local RightCorner = Instance.new("UICorner", Right)
RightCorner.CornerRadius = UDim.new(0, 12)

-- "Server Logs & Join List" title
local LogsTitle = Instance.new("TextLabel")
LogsTitle.Size = UDim2.new(1, 0, 0, 40)
LogsTitle.Position = UDim2.new(0, 12, 0, 10)
LogsTitle.BackgroundTransparency = 1
LogsTitle.Text = "Server Logs & Join List"
LogsTitle.Font = Enum.Font.GothamBold
LogsTitle.TextScaled = true
LogsTitle.TextColor3 = Color3.fromRGB(255,255,255)
LogsTitle.Parent = Right

-- Logs box
local LogBox = Instance.new("TextLabel")
LogBox.Size = UDim2.new(1, -40, 1, -80)
LogBox.Position = UDim2.new(0, 20, 0, 60)
LogBox.BackgroundColor3 = Color3.fromRGB(20,20,22)
LogBox.TextColor3 = Color3.fromRGB(210,210,210)
LogBox.Font = Enum.Font.Code
LogBox.TextSize = 16
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.Text = "[AJ] Auto Join cycle ready.\n[FEATURE] Persistent Rejoin is OFF."
LogBox.Parent = Right
local LogCorner = Instance.new("UICorner", LogBox)
LogCorner.CornerRadius = UDim.new(0,8)

-- AddLog helper
local function AddLog(txt)
	LogBox.Text = LogBox.Text .. "\n" .. txt
end

AddLog("[SYSTEM] UI Loaded.")

-- TWEEN helpers for open/close
local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local contentVisible = true -- starts open

local function CloseUI()
	if not contentVisible then return end
	-- hide content after tween so header remains
	local tween = TweenService:Create(MainFrame, tweenInfo, {Size = CLOSED_SIZE})
	tween:Play()
	tween.Completed:Wait()
	Content.Visible = false
	contentVisible = false
	AddLog("[SYSTEM] UI closed (header visible).")
end

local function OpenUI()
	if contentVisible then return end
	Content.Visible = true
	local tween = TweenService:Create(MainFrame, tweenInfo, {Size = FULL_SIZE})
	tween:Play()
	tween.Completed:Wait()
	contentVisible = true
	AddLog("[SYSTEM] UI opened.")
end

-- Toggle button behaviour
ToggleUI.MouseButton1Click:Connect(function()
	if contentVisible then
		CloseUI()
	else
		OpenUI()
	end
end)

-- Keep status text updated from toggles
task.spawn(function()
	while true do
		Status.Text = AutoJoinEnabled and "Status: Working..." or "Status: Idle"
		task.wait(0.2)
	end
end)

-- Example hotkey: pressing M toggles open/close (useful for testing)
-- (optional) remove if you don't want it
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.M then
		if contentVisible then CloseUI() else OpenUI() end
	end
end)

-- PLACE TO PLUG YOUR AUTOJOIN LOGIC:
-- You can check `AutoJoinEnabled` and `PersistentEnabled` booleans, and read the number in `InputBox.Text`.
-- Example:
-- if AutoJoinEnabled then
--    -- run your join attempt code here
-- end

-- ensure initial state open
Content.Visible = true
MainFrame.Size = FULL_SIZE

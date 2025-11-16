-- Nick & Scrap’s Auto Jointer – FULL UI (fixed spacing, layout, open/close, visuals)
-- Place in StarterPlayerScripts or StarterGui as a LocalScript. UI-only, safe.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- clean previous
local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

-- sizes
local FULL_SIZE = UDim2.new(0, 780, 0, 420)
local HEADER_HEIGHT = 56
local CLOSED_SIZE = UDim2.new(0, 780, 0, HEADER_HEIGHT)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0.5, -390, 0.18, 0)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 33)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)
local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 3
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- subtle rainbow border
task.spawn(function()
	while true do
		for i = 0, 255 do
			Border.Color = Color3.fromHSV(i/255, 0.88, 1)
			task.wait(0.02)
		end
	end
end)

-- Header
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
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(140, 255, 150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Discord (moved right)
local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0, 260, 1, 0)
Discord.Position = UDim2.new(1, -360, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Font = Enum.Font.GothamBold
Discord.TextScaled = true
Discord.TextColor3 = Color3.fromRGB(120, 200, 255)
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/pAgSFBKj")
	end
	Discord.Text = "Copied!"
	task.wait(1.1)
	Discord.Text = "discord.gg/pAgSFBKj"
end)

-- Open/close red button
local ToggleUI = Instance.new("TextButton")
ToggleUI.Size = UDim2.new(0, 36, 0, 36)
ToggleUI.Position = UDim2.new(1, -44, 0.5, -18)
ToggleUI.BackgroundColor3 = Color3.fromRGB(236, 93, 93)
ToggleUI.Text = ""
ToggleUI.Parent = Header
local ToggleCorner = Instance.new("UICorner", ToggleUI)
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleUI.ZIndex = 50

-- Content container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT)
Content.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- LEFT PANEL (Features) - using UIListLayout to prevent overlap
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 260, 1, 0)
LeftPanel.Position = UDim2.new(0, 16, 0, 0) -- small left padding to match screenshot
LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
LeftPanel.Parent = Content
local leftCorner = Instance.new("UICorner", LeftPanel)
leftCorner.CornerRadius = UDim.new(0, 10)

-- inside padding frame (keeps internal padding)
local leftInner = Instance.new("Frame")
leftInner.Size = UDim2.new(1, -16, 1, -24)
leftInner.Position = UDim2.new(0, 8, 0, 12)
leftInner.BackgroundTransparency = 1
leftInner.Parent = LeftPanel

local leftLayout = Instance.new("UIListLayout", leftInner)
leftLayout.Padding = UDim.new(0, 12)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Features header box (looks like screenshot)
local featuresHeader = Instance.new("Frame")
featuresHeader.Size = UDim2.new(1, 0, 0, 48)
featuresHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
featuresHeader.Parent = leftInner
local fhc = Instance.new("UICorner", featuresHeader)
fhc.CornerRadius = UDim.new(0, 8)

local featuresLabel = Instance.new("TextLabel")
featuresLabel.Size = UDim2.new(1, 0, 1, 0)
featuresLabel.BackgroundTransparency = 1
featuresLabel.Text = "Features"
featuresLabel.Font = Enum.Font.GothamBold
featuresLabel.TextScaled = true
featuresLabel.TextColor3 = Color3.fromRGB(245,245,245)
featuresLabel.Parent = featuresHeader

-- Buttons container (frame so buttons have fixed sizes)
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0, 140)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = leftInner

-- Auto Join button
local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Size = UDim2.new(0.93, 0, 0, 46)
AutoJoinBtn.Position = UDim2.new(0.035, 0, 0, 6)
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 85) -- green
AutoJoinBtn.TextColor3 = Color3.fromRGB(20,20,20)
AutoJoinBtn.Text = "Auto Join"
AutoJoinBtn.Font = Enum.Font.GothamBold
AutoJoinBtn.TextScaled = true
AutoJoinBtn.Parent = buttonsFrame
local ajc = Instance.new("UICorner", AutoJoinBtn)
ajc.CornerRadius = UDim.new(0, 8)

local AutoJoinEnabled = false
AutoJoinBtn.MouseButton1Click:Connect(function()
	AutoJoinEnabled = not AutoJoinEnabled
	AutoJoinBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
	-- no logic here, just UI
end)

-- Persistent Rejoin button (separated)
local PersistentBtn = Instance.new("TextButton")
PersistentBtn.Size = UDim2.new(0.93, 0, 0, 44)
PersistentBtn.Position = UDim2.new(0.035, 0, 0, 64)
PersistentBtn.BackgroundColor3 = Color3.fromRGB(56, 58, 62) -- grey/dark
PersistentBtn.TextColor3 = Color3.fromRGB(235,235,235)
PersistentBtn.Text = "Persistent Rejoin"
PersistentBtn.Font = Enum.Font.GothamBold
PersistentBtn.TextScaled = true
PersistentBtn.Parent = buttonsFrame
local prc = Instance.new("UICorner", PersistentBtn)
prc.CornerRadius = UDim.new(0, 8)

local PersistentEnabled = false
PersistentBtn.MouseButton1Click:Connect(function()
	PersistentEnabled = not PersistentEnabled
	PersistentBtn.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-- MINIMUM label and input are separate children of the leftInner so they never overlap
local minContainer = Instance.new("Frame")
minContainer.Size = UDim2.new(1, 0, 0, 86)
minContainer.BackgroundTransparency = 1
minContainer.Parent = leftInner

local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(1, -12, 0, 20)
minLabel.Position = UDim2.new(0, 6, 0, 6)
minLabel.BackgroundTransparency = 1
minLabel.Text = "Minimum/sec (MS) (in Millions)"
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Parent = minContainer

local minBox = Instance.new("TextBox")
minBox.Size = UDim2.new(1, -12, 0, 40)
minBox.Position = UDim2.new(0, 6, 0, 30)
minBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
minBox.Text = "10"
minBox.Font = Enum.Font.GothamBold
minBox.TextSize = 18
minBox.TextColor3 = Color3.fromRGB(255,255,255)
minBox.Parent = minContainer
local minCorner = Instance.new("UICorner", minBox)
minCorner.CornerRadius = UDim.new(0,8)

-- Status label anchored bottom inside LeftPanel (not part of list)
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 18)
Status.Position = UDim2.new(0, 12, 1, -34)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextColor3 = Color3.fromRGB(170,170,170)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = LeftPanel

-- RIGHT PANEL (Logs)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1, -300, 1, 0)
RightPanel.Position = UDim2.new(0, 300, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(30,30,34)
RightPanel.Parent = Content
local rightCorner = Instance.new("UICorner", RightPanel)
rightCorner.CornerRadius = UDim.new(0, 10)

-- Logs header
local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1, 0, 0, 48)
logsHeader.Position = UDim2.new(0, 0, 0, 8)
logsHeader.BackgroundTransparency = 1
logsHeader.Parent = RightPanel

local logsLabel = Instance.new("TextLabel")
logsLabel.Size = UDim2.new(1, -32, 1, 0)
logsLabel.Position = UDim2.new(0, 16, 0, 0)
logsLabel.BackgroundTransparency = 1
logsLabel.Text = "Server Logs & Join List"
logsLabel.Font = Enum.Font.GothamBold
logsLabel.TextScaled = true
logsLabel.TextColor3 = Color3.fromRGB(245,245,245)
logsLabel.Parent = logsHeader

-- Logs box
local LogBox = Instance.new("TextLabel")
LogBox.Size = UDim2.new(1, -48, 1, -88)
LogBox.Position = UDim2.new(0, 24, 0, 64)
LogBox.BackgroundColor3 = Color3.fromRGB(20,20,22)
LogBox.TextColor3 = Color3.fromRGB(210,210,210)
LogBox.Font = Enum.Font.Code
LogBox.TextSize = 15
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.Text = "[AJ] Auto Join cycle ready.\n[FEATURE] Persistent Rejoin is OFF."
LogBox.Parent = RightPanel
local logCorner = Instance.new("UICorner", LogBox)
logCorner.CornerRadius = UDim.new(0, 8)

-- Add log helper
local function AddLog(txt)
	LogBox.Text = LogBox.Text .. "\n" .. txt
end
AddLog("[SYSTEM] UI Loaded.")

-- Tweens & open/close logic (keeps header visible)
local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local contentVisible = true

local function CloseUI()
	if not contentVisible then return end
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

ToggleUI.MouseButton1Click:Connect(function()
	if contentVisible then CloseUI() else OpenUI() end
end)

-- Status update from toggle
task.spawn(function()
	while true do
		Status.Text = AutoJoinEnabled and "Status: Working..." or "Status: Idle"
		task.wait(0.22)
	end
end)

-- hotkey M toggles (debug/testing)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.M then
		if contentVisible then CloseUI() else OpenUI() end
	end
end)

-- ensure initial open state
Content.Visible = true
MainFrame.Size = FULL_SIZE

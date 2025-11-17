-- Nick & Scrap’s Auto Jointer – Compact Final (650 x 400)
-- UI-only, safe. Now includes: toggles, logs, drag, open/close with proper hide.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- clean previous
local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

-- UI size (compact)
local UI_W, UI_H = 650, 400
local FULL_SIZE = UDim2.new(0, UI_W, 0, UI_H)
local HEADER_H = 50
local CLOSED_SIZE = UDim2.new(0, UI_W, 0, HEADER_H)

local LEFT_MARGIN = 14
local LEFT_W = 250
local GAP = 14
local RIGHT_X = LEFT_MARGIN + LEFT_W + GAP
local RIGHT_W = UI_W - RIGHT_X - LEFT_MARGIN

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame
local Main = Instance.new("Frame")
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(28,29,33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3

-- rainbow border
coroutine.wrap(function()
    while true do
        for i = 0, 255 do
            stroke.Color = Color3.fromHSV(i/255, 0.88, 1)
            task.wait(0.02)
        end
    end
end)()

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,HEADER_H)
Header.BackgroundColor3 = Color3.fromRGB(20,20,22)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6,0,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(140,255,150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Parent = Header

-- Discord button
local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0,200,1,0)
Discord.Position = UDim2.new(1, -230, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Font = Enum.Font.GothamBold
Discord.TextSize = 14
Discord.TextColor3 = Color3.fromRGB(120,200,255)
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/pAgSFBKj") end
    local old = Discord.Text
    Discord.Text = "Copied!"
    task.wait(1)
    if Discord then Discord.Text = old end
end)

-- Red toggle button (open/close UI)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,34,0,34)
ToggleBtn.Position = UDim2.new(1, -40, 0.5, -17)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(236,93,93)
ToggleBtn.Text = ""
ToggleBtn.Parent = Header
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

-- Content (will be hidden on close!)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-HEADER_H)
Content.Position = UDim2.new(0,0,0,HEADER_H)
Content.BackgroundTransparency = 1
Content.Parent = Main

-----------------------------------------------------
-- LEFT PANEL
-----------------------------------------------------
local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, LEFT_W, 1, 0)
Left.Position = UDim2.new(0, LEFT_MARGIN, 0, 0)
Left.BackgroundColor3 = Color3.fromRGB(22,23,27)
Left.Parent = Content
Instance.new("UICorner", Left).CornerRadius = UDim.new(0,10)

local leftPad = Instance.new("Frame")
leftPad.Size = UDim2.new(1,-20,1,-24)
leftPad.Position = UDim2.new(0,10,0,12)
leftPad.BackgroundTransparency = 1
leftPad.Parent = Left

local leftLayout = Instance.new("UIListLayout", leftPad)
leftLayout.Padding = UDim.new(0,10)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Feature header
local featHeader = Instance.new("Frame")
featHeader.Size = UDim2.new(1,0,0,44)
featHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
featHeader.Parent = leftPad
Instance.new("UICorner", featHeader).CornerRadius = UDim.new(0,8)

local featLabel = Instance.new("TextLabel")
featLabel.Size = UDim2.new(1,0,1,0)
featLabel.BackgroundTransparency = 1
featLabel.Font = Enum.Font.GothamBold
featLabel.TextSize = 16
featLabel.Text = "Features"
featLabel.TextColor3 = Color3.fromRGB(245,245,245)
featLabel.Parent = featHeader

-----------------------------------------------------
-- Buttons
-----------------------------------------------------
local btnArea = Instance.new("Frame")
btnArea.Size = UDim2.new(1,0,0,120)
btnArea.BackgroundTransparency = 1
btnArea.Parent = leftPad

local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.92,0,0,42)
AutoBtn.Position = UDim2.new(0.04,0,0,6)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.TextColor3 = Color3.fromRGB(20,20,20)
AutoBtn.Text = "Auto Join"
AutoBtn.Parent = btnArea
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0,8)

local PersBtn = Instance.new("TextButton")
PersBtn.Size = UDim2.new(0.92,0,0,40)
PersBtn.Position = UDim2.new(0.04,0,0,56)
PersBtn.BackgroundColor3 = Color3.fromRGB(56,58,62)
PersBtn.Font = Enum.Font.GothamBold
PersBtn.TextSize = 15
PersBtn.TextColor3 = Color3.fromRGB(235,235,235)
PersBtn.Text = "Persistent Rejoin"
PersBtn.Parent = btnArea
Instance.new("UICorner", PersBtn).CornerRadius = UDim.new(0,8)

-----------------------------------------------------
-- MS Input
-----------------------------------------------------
local minFrame = Instance.new("Frame")
minFrame.Size = UDim2.new(1,0,0,74)
minFrame.BackgroundTransparency = 1
minFrame.Parent = leftPad

local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(1,-12,0,18)
minLabel.Position = UDim2.new(0,6,0,6)
minLabel.BackgroundTransparency = 1
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 13
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.Text = "Minimum/sec (MS) (in Millions)"
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Parent = minFrame

local minBox = Instance.new("TextBox")
minBox.Size = UDim2.new(1,-12,0,36)
minBox.Position = UDim2.new(0,6,0,28)
minBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
minBox.TextColor3 = Color3.fromRGB(255,255,255)
minBox.Font = Enum.Font.GothamBold
minBox.TextSize = 16
minBox.Text = "10"
minBox.Parent = minFrame
Instance.new("UICorner", minBox).CornerRadius = UDim.new(0,8)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,18)
Status.Position = UDim2.new(0,10,1,-30)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextColor3 = Color3.fromRGB(170,170,170)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Text = "Status: Idle"
Status.Parent = Left

-----------------------------------------------------
-- Right log panel
-----------------------------------------------------
local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, RIGHT_W, 1, 0)
Right.Position = UDim2.new(0, RIGHT_X, 0, 0)
Right.BackgroundColor3 = Color3.fromRGB(30,30,34)
Right.Parent = Content
Instance.new("UICorner", Right).CornerRadius = UDim.new(0,8)

local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1,0,0,44)
logsHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
logsHeader.Parent = Right
Instance.new("UICorner", logsHeader).CornerRadius = UDim.new(0,8)

local logTitle = Instance.new("TextLabel")
logTitle.Size = UDim2.new(1,0,1,0)
logTitle.BackgroundTransparency = 1
logTitle.Font = Enum.Font.GothamBold
logTitle.TextSize = 16
logTitle.TextColor3 = Color3.fromRGB(245,245,245)
logTitle.Text = "Activity Log"
logTitle.Parent = logsHeader

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-60)
Scroll.Position = UDim2.new(0,10,0,50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 6
Scroll.Parent = Right

local logLayout = Instance.new("UIListLayout", Scroll)
logLayout.Padding = UDim.new(0,6)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- LOG FUNCTION
local function AddLog(text)
	local L = Instance.new("TextLabel")
	L.Size = UDim2.new(1,0,0,22)
	L.BackgroundTransparency = 1
	L.Font = Enum.Font.Gotham
	L.TextSize = 14
	L.TextColor3 = Color3.fromRGB(220,220,220)
	L.TextXAlignment = Enum.TextXAlignment.Left
	L.Text = "• "..text
	L.Parent = Scroll

	task.wait()
	Scroll.CanvasSize = UDim2.new(0,0,0,logLayout.AbsoluteContentSize.Y + 10)
end

-----------------------------------------------------
-- Toggle states
-----------------------------------------------------
local AutoEnabled = false
local PersEnabled = false

-----------------------------------------------------
-- Auto-Join Button
-----------------------------------------------------
AutoBtn.MouseButton1Click:Connect(function()
	AutoEnabled = not AutoEnabled
	
	if AutoEnabled then
		AutoBtn.Text = "Working..."
		Status.Text = "Status: Auto-Join Active"
		AddLog("Auto-Join Enabled")
	else
		AutoBtn.Text = "Auto Join"
		Status.Text = "Status: Idle"
		AddLog("Auto-Join Disabled")
	end
end)

-----------------------------------------------------
-- Persistent Rejoin Button
-----------------------------------------------------
PersBtn.MouseButton1Click:Connect(function()
	PersEnabled = not PersEnabled
	
	if PersEnabled then
		PersBtn.Text = "Running..."
		AddLog("Persistent Rejoin Enabled")
	else
		PersBtn.Text = "Persistent Rejoin"
		AddLog("Persistent Rejoin Disabled")
	end
end)

-----------------------------------------------------
-- OPEN/CLOSE UI (Fully Fixed)
-----------------------------------------------------
local Open = true

ToggleBtn.MouseButton1Click:Connect(function()
	Open = not Open
	
	if Open then
		-- Show content immediately
		Content.Visible = true
		
		-- Expand animation
		TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = FULL_SIZE
		}):Play()
		
		AddLog("UI Opened")
	else
		-- Shrink animation
		TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = CLOSED_SIZE
		}):Play()
		
		AddLog("UI Closed")
		
		-- Hide content AFTER animation finishes
		task.delay(0.23, function()
			if not Open then
				Content.Visible = false
			end
		end)
	end
end)

-----------------------------------------------------
-- DRAGGING (Header)
-----------------------------------------------------
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = Main.Position
	end
end)

Header.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

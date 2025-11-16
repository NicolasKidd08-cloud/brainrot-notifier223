-- Nick & Scrap’s Auto Jointer – Compact Final (Size B: 750x330)
-- UI-only, safe. Use AddLogRow({name="...", ms=1100}) to add real logs.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- clean previous
local existing = PlayerGui:FindFirstChild("NickScrapAutoJointer")
if existing then existing:Destroy() end

--//////////////////////////////////////////////////////////
-- SIZE B CONFIG (750 × 330)
--//////////////////////////////////////////////////////////

local FULL_W = 750
local FULL_H = 330
local FULL_SIZE = UDim2.new(0, FULL_W, 0, FULL_H)

local HEADER_HEIGHT = 56
local CLOSED_SIZE = UDim2.new(0, FULL_W, 0, HEADER_HEIGHT)

-- panel layout
local LEFT_MARGIN = 16
local LEFT_WIDTH = 260
local GAP = 16
local RIGHT_MARGIN = 16

local RIGHT_X = LEFT_MARGIN + LEFT_WIDTH + GAP
local RIGHT_WIDTH = FULL_W - RIGHT_X - RIGHT_MARGIN

--//////////////////////////////////////////////////////////
-- MAIN GUI
--//////////////////////////////////////////////////////////

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJointer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -FULL_W/2, 0.5, -FULL_H/2)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICornerM = Instance.new("UICorner", Main)
UICornerM.CornerRadius = UDim.new(0, 12)

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = Main

local UICornerH = Instance.new("UICorner", Header)
UICornerH.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Nick & Scrap's Auto Jointer"
Title.Parent = Header

----------------------------------------------------------------
-- OPEN/CLOSE TOGGLE (^)
----------------------------------------------------------------

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(1, -45, 0.5, -20)
Toggle.BackgroundTransparency = 1
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 28
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Text = "^"
Toggle.Parent = Header

local isOpen = true
Toggle.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	Toggle.Text = isOpen and "^" or "v"
	local goal = {}
	goal.Size = isOpen and FULL_SIZE or CLOSED_SIZE
	local tween = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), goal)
	tween:Play()
end)

----------------------------------------------------------------
-- LEFT PANEL
----------------------------------------------------------------

local Left = Instance.new("Frame")
Left.Name = "Left"
Left.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Left.Position = UDim2.new(0, LEFT_MARGIN, 0, HEADER_HEIGHT + 12)
Left.Size = UDim2.new(0, LEFT_WIDTH, 1, -HEADER_HEIGHT - 28)
Left.BorderSizePixel = 0
Left.Parent = Main

Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 10)

-------------------------------------------
-- INPUT: Minimum Seconds (MS)
-------------------------------------------

local MSLabel = Instance.new("TextLabel")
MSLabel.Parent = Left
MSLabel.BackgroundTransparency = 1
MSLabel.Position = UDim2.new(0, 12, 0, 8)
MSLabel.Size = UDim2.new(1, -24, 0, 22)
MSLabel.Font = Enum.Font.GothamMedium
MSLabel.TextSize = 16
MSLabel.TextXAlignment = Enum.TextXAlignment.Left
MSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MSLabel.Text = "Minimum Seconds (MS):"

local MSText = Instance.new("TextBox")
MSText.Parent = Left
MSText.Position = UDim2.new(0, 12, 0, 34)
MSText.Size = UDim2.new(1, -24, 0, 32)
MSText.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MSText.Font = Enum.Font.GothamMedium
MSText.TextSize = 16
MSText.TextColor3 = Color3.fromRGB(255, 255, 255)
MSText.PlaceholderText = "Enter MS"
MSText.ClearTextOnFocus = false

Instance.new("UICorner", MSText).CornerRadius = UDim.new(0, 8)

-------------------------------------------
-- DISCORD LINK BUTTON
-------------------------------------------

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Parent = Left
DiscordBtn.Position = UDim2.new(0, 12, 0, 80)
DiscordBtn.Size = UDim2.new(1, -24, 0, 34)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 16
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Text = "Copy Discord Link"

Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

DiscordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/yourlinkhere")
	DiscordBtn.Text = "Copied!"
	task.delay(1.0, function()
		DiscordBtn.Text = "Copy Discord Link"
	end)
end)

----------------------------------------------------------------
-- RIGHT PANEL (LOGS)
----------------------------------------------------------------

local Right = Instance.new("Frame")
Right.Name = "Right"
Right.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Right.Position = UDim2.new(0, RIGHT_X, 0, HEADER_HEIGHT + 12)
Right.Size = UDim2.new(0, RIGHT_WIDTH, 1, -HEADER_HEIGHT - 28)
Right.BorderSizePixel = 0
Right.Parent = Main

Instance.new("UICorner", Right).CornerRadius = UDim.new(0, 10)

local LogList = Instance.new("UIListLayout")
LogList.Parent = Right
LogList.SortOrder = Enum.SortOrder.LayoutOrder
LogList.Padding = UDim.new(0, 6)

local function AddLogRow(data)
	local Row = Instance.new("TextLabel")
	Row.Parent = Right
	Row.Size = UDim2.new(1, -12, 0, 28)
	Row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Row.Font = Enum.Font.GothamMedium
	Row.TextSize = 14
	Row.TextColor3 = Color3.fromRGB(255, 255, 255)
	Row.TextXAlignment = Enum.TextXAlignment.Left
	Row.Text = "[Brainrot] " .. data.name .. " — " .. data.ms .. "ms"
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
end

-- demo log
AddLogRow({name="Example Brainrot", ms=1100})

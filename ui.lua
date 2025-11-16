local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- clean previous
local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

-- UI size (compact and resized to fit better)
local UI_W, UI_H = 650, 350  -- smaller height to take up less room
local FULL_SIZE = UDim2.new(0, UI_W, 0, UI_H)
local HEADER_H = 45  -- smaller header height
local CLOSED_SIZE = UDim2.new(0, UI_W, 0, HEADER_H)

-- Left panel width and spacing
local LEFT_MARGIN = 14
local LEFT_W = 230  -- slightly narrower left panel
local GAP = 14
local RIGHT_X = LEFT_MARGIN + LEFT_W + GAP
local RIGHT_W = UI_W - RIGHT_X - LEFT_MARGIN

-- create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- main frame (center-ish)
local Main = Instance.new("Frame")
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(28,29,33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui

local mc = Instance.new("UICorner", Main)
mc.CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- subtle rainbow border
task.spawn(function()
	while true do
		for i = 0, 255 do
			stroke.Color = Color3.fromHSV(i/255, 0.88, 1)
			task.wait(0.02)
		end
	end
end)

-- header (always visible)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,HEADER_H)
Header.Position = UDim2.new(0,0,0,0)
Header.BackgroundColor3 = Color3.fromRGB(20,20,22)
Header.Parent = Main
local hc = Instance.new("UICorner", Header); hc.CornerRadius = UDim.new(0,10)

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

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,34,0,34)
ToggleBtn.Position = UDim2.new(1, -40, 0.5, -17)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(236,93,93)
ToggleBtn.Text = ""
ToggleBtn.Parent = Header
local tc = Instance.new("UICorner", ToggleBtn); tc.CornerRadius = UDim.new(1,0)

-- content (togglable)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1, -HEADER_H)
Content.Position = UDim2.new(0,0,0,HEADER_H)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- LEFT PANEL (Features) sized and stacked: Features title, AutoJoin (top), Persistent (middle), Minimum (bottom)
local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, LEFT_W, 1, 0)
Left.Position = UDim2.new(0, LEFT_MARGIN, 0, 0)
Left.BackgroundColor3 = Color3.fromRGB(22,23,27)
Left.Parent = Content
local lc = Instance.new("UICorner", Left); lc.CornerRadius = UDim.new(0,10)

-- internal left padding
local leftPad = Instance.new("Frame")
leftPad.Size = UDim2.new(1,-20,1,-24)
leftPad.Position = UDim2.new(0,10,0,12)
leftPad.BackgroundTransparency = 1
leftPad.Parent = Left

local leftLayout = Instance.new("UIListLayout", leftPad)
leftLayout.Padding = UDim.new(0,10)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Features header box
local featHeader = Instance.new("Frame")
featHeader.Size = UDim2.new(1,0,0,44)
featHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
featHeader.Parent = leftPad
local fh = Instance.new("UICorner", featHeader); fh.CornerRadius = UDim.new(0,8)
local featLabel = Instance.new("TextLabel")
featLabel.Size = UDim2.new(1,0,1,0)
featLabel.BackgroundTransparency = 1
featLabel.Font = Enum.Font.GothamBold
featLabel.TextSize = 16
featLabel.Text = "Features"
featLabel.TextColor3 = Color3.fromRGB(245,245,245)
featLabel.Parent = featHeader

-- Buttons area frame to control positions
local btnArea = Instance.new("Frame")
btnArea.Size = UDim2.new(1,0,0,120)
btnArea.BackgroundTransparency = 1
btnArea.Parent = leftPad

-- Auto Join button (top)
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.92,0,0,42)
AutoBtn.Position = UDim2.new(0.04,0,0,6)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.TextColor3 = Color3.fromRGB(20,20,20)
AutoBtn.Text = "Auto Join"
AutoBtn.Parent = btnArea
local abc = Instance.new("UICorner", AutoBtn); abc.CornerRadius = UDim.new(0,8)

-- Persistent button (middle)
local PersBtn = Instance.new("TextButton")
PersBtn.Size = UDim2.new(0.92,0,0,40)
PersBtn.Position = UDim2.new(0.04,0,0,56)
PersBtn.BackgroundColor3 = Color3.fromRGB(56,58,62)
PersBtn.Font = Enum.Font.GothamBold
PersBtn.TextSize = 15
PersBtn.TextColor3 = Color3.fromRGB(235,235,235)
PersBtn.Text = "Persistent Rejoin"
PersBtn.Parent = btnArea
local pbc = Instance.new("UICorner", PersBtn); pbc.CornerRadius = UDim.new(0,8)

-- Minimum area (bottom inside leftPad)
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
local minc = Instance.new("UICorner", minBox); minc.CornerRadius = UDim.new(0,8)

-- status (bottom-left)
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

-- RIGHT panel (logs)
local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, RIGHT_W, 1, 0)
Right.Position = UDim2.new(0, RIGHT_X, 0, 0)
Right.BackgroundColor3 = Color3.fromRGB(30,30,34)
Right.Parent = Content
local rc = Instance.new("UICorner", Right); rc.CornerRadius = UDim.new(0,8)

-- logs header
local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1,0,0,44)
logsHeader.Position = UDim2.new(0,0,0,8)
logsHeader.BackgroundTransparency = 1
logsHeader.Parent = Right

local logsLabel = Instance.new("TextLabel")
logsLabel.Size = UDim2.new(1,-24,1,0)
logsLabel.Position = UDim2.new(0,12,0,0)
logsLabel.BackgroundTransparency = 1
logsLabel.Font = Enum.Font.GothamBold
logsLabel.TextSize = 16
logsLabel.TextColor3 = Color3.fromRGB(245,245,245)
logsLabel.Text = "Server Logs & Join List"
logsLabel.Parent = logsHeader

-- scrolling area for rows
local logsScroll = Instance.new("ScrollingFrame")
logsScroll.Size = UDim2.new(1,-32,1,-92)
logsScroll.Position = UDim2.new(0,16,0,56)
logsScroll.BackgroundTransparency = 1
logsScroll.CanvasSize = UDim2.new(0,0,0,0)
logsScroll.ScrollBarThickness = 8
logsScroll.Parent = Right

local logsLayout = Instance.new("UIListLayout", logsScroll)
logsLayout.SortOrder = Enum.SortOrder.LayoutOrder
logsLayout.Padding = UDim.new(0,8)

-- formatting helpers
local function formatMoney(n)
	n = tonumber(n) or 0
	return string.format("%.2fM/s", n)
end

-- Join placeholder (replace with Teleport or RemoteEvent)
local function JoinServer(data)
	-- data = { name = "...", ms = 1100, row = frame }
	-- placeholder: visual flash
	if not data or not data.row then return end
	local f = data.row
	local orig = f.BackgroundColor3
	f.BackgroundColor3 = Color3.fromRGB(28,70,40)
	task.wait(0.16)
	if f and f.Parent then f.BackgroundColor3 = orig end
	-- add textual log if desired
	-- AddTextLog("[Join] "..tostring(data.name).." ("..tostring(data.ms)..")")
	return true
end

-- function to create a single log row (shrunk to fit the compact UI)
local function NewLogRow(data)
	-- data: { name = "...", ms = 1100 }
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,44)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,22)
	frame.BorderSizePixel = 0
	frame.Parent = logsScroll
	local fc = Instance.new("UICorner", frame); fc.CornerRadius = UDim.new(0,8)

	-- left: name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0,12,0,0)
	nameLabel.Size = UDim2.new(0.55, -12, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = Color3.fromRGB(235,235,235)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = tostring(data.name or "Unknown")
	nameLabel.Parent = frame

	-- right: money (neon green), right aligned but leaves space for join button
	local moneyLabel = Instance.new("TextLabel")
	moneyLabel.BackgroundTransparency = 1
	moneyLabel.Size = UDim2.new(0, 110, 1, 0)
	moneyLabel.Position = UDim2.new(1, -150, 0, 0) -- leaves 70px for button + spacing
	moneyLabel.Font = Enum.Font.GothamBold
	moneyLabel.TextSize = 14
	moneyLabel.TextColor3 = Color3.fromRGB(60,240,160)
	moneyLabel.TextXAlignment = Enum.TextXAlignment.Right
	moneyLabel.Text = formatMoney(data.ms)
	moneyLabel.Parent = frame

	-- join button (far right)
	local joinBtn = Instance.new("TextButton")
	joinBtn.Size = UDim2.new(0,66,0,30)
	joinBtn.Position = UDim2.new(1, -74, 0.5, -15)
	joinBtn.BackgroundColor3 = Color3.fromRGB(60,70,75)
	joinBtn.Font = Enum.Font.GothamBold
	joinBtn.TextSize = 13
	joinBtn.Text = "Join"
	joinBtn.TextColor3 = Color3.fromRGB(245,245,245)
	joinBtn.Parent = frame
	local jc = Instance.new("UICorner", joinBtn); jc.CornerRadius = UDim.new(0,6)

	-- container
	local container = { name = data.name, ms = data.ms, row = frame, joinBtn = joinBtn }

	-- click handler - calls placeholder JoinServer (safe)
	joinBtn.MouseButton1Click:Connect(function()
		pcall(function()
			JoinServer(container)
		end)
	end)

	return container
end

-- AddLogRow public: call with table { name = "...", ms = 1100 }
local AutoJoinEnabled = false
local PersistentEnabled = false

local function recalcCanvas()
	local total = 0
	for _, c in ipairs(logsScroll:GetChildren()) do
		if c:IsA("Frame") then
			total = total + c.AbsoluteSize.Y + logsLayout.Padding.Offset
		end
	end
	logsScroll.CanvasSize = UDim2.new(0,0,0, math.max(0, total + 8))
end

local function AddLogRow(data)
	-- require proper format
	if type(data) ~= "table" or not data.name or not data.ms then
		warn("AddLogRow: expected table {name=..., ms=...}")
		return
	end

	-- create at top: set LayoutOrder 0 and push others down
	for _, child in ipairs(logsScroll:GetChildren()) do
		if child:IsA("Frame") then
			child.LayoutOrder = (child.LayoutOrder or 0) + 1
		end
	end

	local entry = NewLogRow(data)
	entry.row.LayoutOrder = 0

	-- recalc canvas (defer a frame to ensure AbsoluteSize valid)
	task.defer(recalcCanvas)

	-- if AutoJoin enabled, trigger join attempts (respect Persistent)
	if AutoJoinEnabled then
		coroutine.wrap(function()
			local attempts = PersistentEnabled and 5 or 1
			local delayBetween = math.max(0.5, tonumber(minBox.Text) or 1)
			local succeeded = false
			for i = 1, attempts do
				local ok, err = pcall(function() JoinServer(entry) end)
				if ok then
					succeeded = true
					break
				else
					AddLogRow({ name = "[AUTO-ERR] "..tostring(data.name), ms = 0 })
				end
				if i < attempts then task.wait(delayBetween * 0.5) end
			end
		end)()
	end

	return entry
end

-- toggles
AutoBtn.MouseButton1Click:Connect(function()
	AutoJoinEnabled = not AutoJoinEnabled
	AutoBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
end)

PersBtn.MouseButton1Click:Connect(function()
	PersistentEnabled = not PersistentEnabled
	PersBtn.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-- open/close tween
local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local visible = true
local function CloseUI()
	if not visible then return end
	local t = TweenService:Create(Main, tweenInfo, { Size = CLOSED_SIZE })
	t:Play(); t.Completed:Wait()
	Content.Visible = false
	

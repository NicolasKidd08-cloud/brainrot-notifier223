-- Nick & Scrap’s Auto Jointer – FINAL (1000x600, log rows, auto-join & persistent retry placeholders)
-- Place in StarterPlayerScripts or StarterGui as a LocalScript. UI-only / safe by default.
-- Use AddLogRow(name, money) to add rows (money is numeric, representing Millions or raw value - displayed as e.g. "10.00M/s")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- remove old
local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

-- dimensions (1000 x 600 square-ish)
local FULL_W, FULL_H = 1000, 600
local FULL_SIZE = UDim2.new(0, FULL_W, 0, FULL_H)
local HEADER_HEIGHT = 56
local CLOSED_SIZE = UDim2.new(0, FULL_W, 0, HEADER_HEIGHT)

-- layout metrics
local LEFT_MARGIN = 20
local LEFT_WIDTH = 320
local GAP = 20
local RIGHT_MARGIN = 20
local RIGHT_X = LEFT_MARGIN + LEFT_WIDTH + GAP
local RIGHT_WIDTH = FULL_W - RIGHT_X - RIGHT_MARGIN

-- create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0.5, -FULL_W/2, 0.12, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28,29,33)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)
local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 3
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- subtle rainbow border loop
task.spawn(function()
	while true do
		for i = 0, 255 do
			Border.Color = Color3.fromHSV(i/255, 0.88, 1)
			task.wait(0.02)
		end
	end
end)

-- header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(20,20,22)
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- title (20px bold)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 360, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(140,255,150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- discord (18px)
local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0, 260, 1, 0)
Discord.Position = UDim2.new(1, -360, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Font = Enum.Font.GothamBold
Discord.TextSize = 18
Discord.TextColor3 = Color3.fromRGB(120,200,255)
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard("https://discord.gg/pAgSFBKj") end
	local old = Discord.Text
	Discord.Text = "Copied!"
	task.wait(1)
	Discord.Text = old
end)

-- open/close red button
local ToggleUI = Instance.new("TextButton")
ToggleUI.Size = UDim2.new(0, 36, 0, 36)
ToggleUI.Position = UDim2.new(1, -44, 0.5, -18)
ToggleUI.BackgroundColor3 = Color3.fromRGB(236,93,93)
ToggleUI.Text = ""
ToggleUI.Parent = Header
local ToggleCorner = Instance.new("UICorner", ToggleUI)
ToggleCorner.CornerRadius = UDim.new(1, 0)

-- content container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT)
Content.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ---------------------------
-- LEFT: FEATURES PANEL
-- ---------------------------
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, LEFT_WIDTH, 1, 0)
LeftPanel.Position = UDim2.new(0, LEFT_MARGIN, 0, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(22,23,27)
LeftPanel.Parent = Content
local LeftCorner = Instance.new("UICorner", LeftPanel)
LeftCorner.CornerRadius = UDim.new(0, 10)

local leftInner = Instance.new("Frame")
leftInner.Size = UDim2.new(1, -24, 1, -28)
leftInner.Position = UDim2.new(0, 12, 0, 12)
leftInner.BackgroundTransparency = 1
leftInner.Parent = LeftPanel

local leftList = Instance.new("UIListLayout", leftInner)
leftList.Padding = UDim.new(0, 12)
leftList.SortOrder = Enum.SortOrder.LayoutOrder
leftList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Features header (box)
local featuresHeader = Instance.new("Frame")
featuresHeader.Size = UDim2.new(1, 0, 0, 48)
featuresHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
featuresHeader.Parent = leftInner
local fhc = Instance.new("UICorner", featuresHeader)
fhc.CornerRadius = UDim.new(0,8)

local featuresLabel = Instance.new("TextLabel")
featuresLabel.Size = UDim2.new(1,0,1,0)
featuresLabel.BackgroundTransparency = 1
featuresLabel.Text = "Features"
featuresLabel.Font = Enum.Font.GothamBold
featuresLabel.TextSize = 20
featuresLabel.TextColor3 = Color3.fromRGB(245,245,245)
featuresLabel.Parent = featuresHeader

-- buttons frame (explicit positions to match reference)
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1,0,0,140)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = leftInner

local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Size = UDim2.new(0.92,0,0,46)
AutoJoinBtn.Position = UDim2.new(0.04,0,0,6)
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
AutoJoinBtn.Text = "Auto Join"
AutoJoinBtn.Font = Enum.Font.GothamBold
AutoJoinBtn.TextSize = 18
AutoJoinBtn.TextColor3 = Color3.fromRGB(20,20,20)
AutoJoinBtn.Parent = buttonsFrame
local ajc = Instance.new("UICorner", AutoJoinBtn)
ajc.CornerRadius = UDim.new(0,8)

local PersistentBtn = Instance.new("TextButton")
PersistentBtn.Size = UDim2.new(0.92,0,0,44)
PersistentBtn.Position = UDim2.new(0.04,0,0,64)
PersistentBtn.BackgroundColor3 = Color3.fromRGB(56,58,62)
PersistentBtn.Text = "Persistent Rejoin"
PersistentBtn.Font = Enum.Font.GothamBold
PersistentBtn.TextSize = 17
PersistentBtn.TextColor3 = Color3.fromRGB(235,235,235)
PersistentBtn.Parent = buttonsFrame
local prc = Instance.new("UICorner", PersistentBtn)
prc.CornerRadius = UDim.new(0,8)

-- minimum area (separate)
local minContainer = Instance.new("Frame")
minContainer.Size = UDim2.new(1,0,0,86)
minContainer.BackgroundTransparency = 1
minContainer.Parent = leftInner

local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(1,-12,0,20)
minLabel.Position = UDim2.new(0,6,0,6)
minLabel.BackgroundTransparency = 1
minLabel.Text = "Minimum/sec (MS) (in Millions)"
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Parent = minContainer

local minBox = Instance.new("TextBox")
minBox.Size = UDim2.new(1,-12,0,40)
minBox.Position = UDim2.new(0,6,0,30)
minBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
minBox.Text = "10"
minBox.Font = Enum.Font.GothamBold
minBox.TextSize = 18
minBox.TextColor3 = Color3.fromRGB(255,255,255)
minBox.Parent = minContainer
local minCorner = Instance.new("UICorner", minBox)
minCorner.CornerRadius = UDim.new(0,8)

-- status bottom left
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-24,0,18)
Status.Position = UDim2.new(0,12,1,-34)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.Font = Enum.Font.Gotham
Status.TextSize = 15
Status.TextColor3 = Color3.fromRGB(170,170,170)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = LeftPanel

-- ---------------------------
-- RIGHT: LOGS PANEL
-- ---------------------------
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, RIGHT_WIDTH, 1, 0)
RightPanel.Position = UDim2.new(0, RIGHT_X, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(30,30,34)
RightPanel.Parent = Content
local rightCorner = Instance.new("UICorner", RightPanel)
rightCorner.CornerRadius = UDim.new(0,10)

-- logs header label
local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1,0,0,48)
logsHeader.Position = UDim2.new(0,0,0,8)
logsHeader.BackgroundTransparency = 1
logsHeader.Parent = RightPanel

local logsLabel = Instance.new("TextLabel")
logsLabel.Size = UDim2.new(1,-32,1,0)
logsLabel.Position = UDim2.new(0,16,0,0)
logsLabel.BackgroundTransparency = 1
logsLabel.Text = "Server Logs & Join List"
logsLabel.Font = Enum.Font.GothamBold
logsLabel.TextSize = 20
logsLabel.TextColor3 = Color3.fromRGB(245,245,245)
logsLabel.Parent = logsHeader

-- logs scroll area
local logsScroll = Instance.new("ScrollingFrame")
logsScroll.Size = UDim2.new(1,-48,1,-120)
logsScroll.Position = UDim2.new(0,24,0,64)
logsScroll.BackgroundTransparency = 1
logsScroll.CanvasSize = UDim2.new(0,0,0,0)
logsScroll.ScrollBarThickness = 6
logsScroll.Parent = RightPanel

local logsList = Instance.new("UIListLayout", logsScroll)
logsList.SortOrder = Enum.SortOrder.LayoutOrder
logsList.Padding = UDim.new(0,8)

-- helper: create single row style (dark row, left name, right money, join button)
local function FormatMoney(m)
	-- m is numeric; we format as "10.00M/s" if large. Keep it simple:
	local n = tonumber(m) or 0
	-- treat numeric as millions already if > 1 -> show with 2 decimals
	return string.format("%.2fM/s", n)
end

local function CreateLogRow(name, money)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 48)
	row.BackgroundColor3 = Color3.fromRGB(21,21,22) -- dark row
	row.BorderSizePixel = 0
	row.Parent = logsScroll
	local rc = Instance.new("UICorner", row)
	rc.CornerRadius = UDim.new(0,8)

	-- left label
	local left = Instance.new("TextLabel")
	left.BackgroundTransparency = 1
	left.Position = UDim2.new(0, 12, 0, 0)
	left.Size = UDim2.new(0.55, -12, 1, 0)
	left.TextXAlignment = Enum.TextXAlignment.Left
	left.Font = Enum.Font.Gotham
	left.TextSize = 16
	left.TextColor3 = Color3.fromRGB(235,235,235)
	left.Text = tostring(name)
	left.Parent = row

	-- right (money) label neon green
	local right = Instance.new("TextLabel")
	right.BackgroundTransparency = 1
	right.Position = UDim2.new(1, -180, 0, 0)
	right.Size = UDim2.new(0, 130, 1, 0)
	right.TextXAlignment = Enum.TextXAlignment.Right
	right.Font = Enum.Font.GothamBold
	right.TextSize = 16
	right.TextColor3 = Color3.fromRGB(60, 240, 160) -- neon green
	right.Text = FormatMoney(money)
	right.Parent = row

	-- small join button on the far right
	local joinBtn = Instance.new("TextButton")
	joinBtn.Size = UDim2.new(0, 60, 0, 30)
	joinBtn.Position = UDim2.new(1, -70, 0.5, -15)
	joinBtn.BackgroundColor3 = Color3.fromRGB(60,70,75)
	joinBtn.Font = Enum.Font.GothamBold
	joinBtn.TextSize = 14
	joinBtn.Text = "Join"
	joinBtn.TextColor3 = Color3.fromRGB(245,245,245)
	joinBtn.Parent = row
	local jrc = Instance.new("UICorner", joinBtn)
	jrc.CornerRadius = UDim.new(0,6)

	-- data container
	local data = { name = name, money = money, frame = row, joinBtn = joinBtn }

	-- join behavior (local placeholder)
	local function doJoin()
		AddLog("[ACTION] Attempting join to: "..tostring(name).." @ "..tostring(money))
		-- local placeholder join function: replace with teleport or remote calls if desired
		local ok, err = pcall(function()
			-- placeholder: simulate success immediately
			-- If you want real joining, replace JoinServer below with TeleportService or RemoteEvent.
			JoinServer(data)
		end)
		if not ok then
			AddLog("[ERROR] Join failed: "..tostring(err))
		end
	end

	joinBtn.MouseButton1Click:Connect(doJoin)

	return data
end

-- AddLogRow: creates a row at top. If AutoJoinEnabled, triggers join
local function AddLogRow(name, money)
	-- create row
	local data = CreateLogRow(name, money)
	-- insert at top by setting LayoutOrder negative increasing
	-- we'll shift existing children layout orders by +1
	for i, child in ipairs(logsScroll:GetChildren()) do
		-- only UI elements with LayoutOrder set by us
		if child:IsA("Frame") then
			local lo = child.LayoutOrder or 0
			child.LayoutOrder = lo + 1
		end
	end
	data.frame.LayoutOrder = 0

	-- update canvas size
	local total = 0
	for _, ch in ipairs(logsScroll:GetChildren()) do
		if ch:IsA("Frame") then
			total = total + ch.AbsoluteSize.Y + logsList.Padding.Offset
		end
	end
	logsScroll.CanvasSize = UDim2.new(0, 0, 0, total + 12)

	-- If AutoJoin ON then try to join
	if AutoJoinEnabled then
		-- run join in a safe pcall
		coroutine.wrap(function()
			-- attempt join (respects PersistentEnabled)
			local attempts = PersistentEnabled and 6 or 1
			local delayBetween = tonumber(minBox.Text) or 1
			local success = false
			for i=1, attempts do
				-- call local placeholder join
				local ok, err = pcall(function()
					JoinServer(data)
				end)
				if ok then
					success = true
					AddLog("[AUTO] Joined "..tostring(name).." on attempt "..i)
					break
				else
					AddLog("[AUTO] Join attempt "..i.." failed for "..tostring(name))
				end
				if i < attempts then
					task.wait(math.max(0.6, delayBetween/10)) -- small wait; ms text is millions label so make small pause
				end
			end
			if not success then
				AddLog("[AUTO] Failed to auto-join "..tostring(name))
			end
		end)()
	end
end

-- AddLog helper for textual log area (not the row table)
local function AddLog(txt)
	-- append to invisible textual log (we'll also add to List if desired)
	print(txt)
	-- Also add a small textual row as a backup log (optional)
end

-- Placeholder local join function (you can replace this)
function JoinServer(data)
	-- data = { name=..., money=..., frame=..., joinBtn=... }
	-- This placeholder simulates success. Replace with TeleportService:TeleportToPlaceInstance or RemoteEvent call as needed.
	AddLog("[JoinServer] Simulated join for " .. tostring(data.name) .. " — " .. tostring(data.money))
	-- Visual feedback: flash row background green briefly
	local f = data.frame
	local orig = f.BackgroundColor3
	f.BackgroundColor3 = Color3.fromRGB(30,80,50)
	task.wait(0.18)
	if f and f.Parent then
		f.BackgroundColor3 = orig
	end
	return true
end

-- toggles behavior
local AutoJoinEnabled = false
local PersistentEnabled = false

AutoJoinBtn.MouseButton1Click:Connect(function()
	AutoJoinEnabled = not AutoJoinEnabled
	AutoJoinBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
end)

PersistentBtn.MouseButton1Click:Connect(function()
	PersistentEnabled = not PersistentEnabled
	PersistentBtn.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-- open/close tween functions
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

-- Status updater
task.spawn(function()
	while true do
		Status.Text = AutoJoinEnabled and "Status: Working..." or "Status: Idle"
		task.wait(0.2)
	end
end)

-- keyboard M toggle (debug)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.M then
		if contentVisible then CloseUI() else OpenUI() end
	end
end)

-- ensure initial open
Content.Visible = true
MainFrame.Size = FULL_SIZE

-- ---------------------------
-- Example usage / demo logs
-- ---------------------------
-- You can remove these demo calls later. They show how rows appear.
task.delay(0.6, function() AddLogRow("Dragon Connectioni", 1100) end)
task.delay(1.4, function() AddLogRow("Estok Sekolah", 135) end)
task.delay(2.0, function() AddLogRow("Ketupat Kepat", 280) end)
task.delay(2.8, function() AddLogRow("Ketupat Kepat", 490) end)
task.delay(3.6, function() AddLogRow("New Player", 10) end)

-- Expose AddLogRow to global so other scripts can call it:
_G.NickScrap_AddLogRow = AddLogRow


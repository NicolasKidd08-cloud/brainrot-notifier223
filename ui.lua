--// Nicolas AutoJoiner UI (SAFE UI ONLY – NO EXPLOITS)

local UIS = game:GetService("UserInputService")

--// MAIN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NicolasAutoJoinerUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

--// MAIN FRAME (550x350)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 14)

-- Rainbow Outline
local Rainbow = Instance.new("UIStroke", Main)
Rainbow.Thickness = 2
Rainbow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Rainbow animation
task.spawn(function()
	while true do
		for i = 0, 255 do
			Rainbow.Color = Color3.fromHSV(i/255, 1, 1)
			task.wait(0.02)
		end
	end
end)

--// TOP BAR (Luarmor Style)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 10)

-- Divider line under top bar
local DividerTop = Instance.new("Frame")
DividerTop.Size = UDim2.new(1, -10, 0, 2)
DividerTop.Position = UDim2.new(0, 5, 0, 45)
DividerTop.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
DividerTop.BorderSizePixel = 0
DividerTop.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Nicolas's AutoJoiner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = TopBar

-- Discord
local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(1, 0, 0, 18)
Discord.Position = UDim2.new(0, 0, 0, 24)
Discord.BackgroundTransparency = 1
Discord.Text = "discord.gg/Kzzwxg89"
Discord.TextColor3 = Color3.fromRGB(200, 200, 200)
Discord.Font = Enum.Font.GothamSemibold
Discord.TextSize = 16
Discord.Parent = TopBar

-- Minimize button (red glow)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 25)
MinBtn.Position = UDim2.new(1, -45, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.TextSize = 22
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner", MinBtn)
MinCorner.CornerRadius = UDim.new(0, 6)

-- Minimize Function
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	for _, v in ipairs(Main:GetChildren()) do
		if v ~= TopBar and v ~= DividerTop then
			v.Visible = not Minimized
		end
	end
end)

--// LEFT FEATURE PANEL
local FeaturePanel = Instance.new("Frame")
FeaturePanel.Size = UDim2.new(0, 160, 0, 305)
FeaturePanel.Position = UDim2.new(0, 0, 0, 52)
FeaturePanel.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
FeaturePanel.BorderSizePixel = 0
FeaturePanel.Parent = Main

local FeatureCorner = Instance.new("UICorner", FeaturePanel)
FeatureCorner.CornerRadius = UDim.new(0, 12)

-- Divider between Features + Brainrot list
local DividerVertical = Instance.new("Frame")
DividerVertical.Size = UDim2.new(0, 3, 1, -55)
DividerVertical.Position = UDim2.new(0, 160, 0, 52)
DividerVertical.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
DividerVertical.BorderSizePixel = 0
DividerVertical.Parent = Main

-- Features text
local FeatureTitle = Instance.new("TextLabel")
FeatureTitle.Size = UDim2.new(1, 0, 0, 30)
FeatureTitle.BackgroundTransparency = 1
FeatureTitle.Text = "Features"
FeatureTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FeatureTitle.Font = Enum.Font.GothamBold
FeatureTitle.TextSize = 18
FeatureTitle.Parent = FeaturePanel

-- AutoJoin toggle (UI only)
local AutoJoin = Instance.new("TextLabel")
AutoJoin.Size = UDim2.new(1, -20, 0, 25)
AutoJoin.Position = UDim2.new(0, 10, 0, 40)
AutoJoin.BackgroundTransparency = 1
AutoJoin.Text = "• Auto Join"
AutoJoin.TextColor3 = Color3.fromRGB(180, 180, 255)
AutoJoin.Font = Enum.Font.GothamMedium
AutoJoin.TextSize = 16
AutoJoin.Parent = FeaturePanel

-- Minimum Per Second text (UI only)
local MinPS = Instance.new("TextLabel")
MinPS.Size = UDim2.new(1, -20, 0, 25)
MinPS.Position = UDim2.new(0, 10, 0, 75)
MinPS.BackgroundTransparency = 1
MinPS.Text = "• Minimum / sec"
MinPS.TextColor3 = Color3.fromRGB(180, 180, 255)
MinPS.Font = Enum.Font.GothamMedium
MinPS.TextSize = 16
MinPS.Parent = FeaturePanel

-- Ignore list text (UI only)
local IgnoreLbl = Instance.new("TextLabel")
IgnoreLbl.Size = UDim2.new(1, -20, 0, 25)
IgnoreLbl.Position = UDim2.new(0, 10, 0, 110)
IgnoreLbl.BackgroundTransparency = 1
IgnoreLbl.Text = "• Ignore List"
IgnoreLbl.TextColor3 = Color3.fromRGB(180, 180, 255)
IgnoreLbl.Font = Enum.Font.GothamMedium
IgnoreLbl.TextSize = 16
IgnoreLbl.Parent = FeaturePanel

--// RIGHT BRAINROT LIST AREA
local LogFrame = Instance.new("Frame")
LogFrame.Size = UDim2.new(1, -165, 1, -55)
LogFrame.Position = UDim2.new(0, 165, 0, 52)
LogFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
LogFrame.BorderSizePixel = 0
LogFrame.Parent = Main

local LogCorner = Instance.new("UICorner", LogFrame)
LogCorner.CornerRadius = UDim.new(0, 12)

local NoData = Instance.new("TextLabel")
NoData.Size = UDim2.new(1, 0, 1, 0)
NoData.BackgroundTransparency = 1
NoData.Text = "Brainrot list loads here"
NoData.TextColor3 = Color3.fromRGB(200, 200, 200)
NoData.Font = Enum.Font.GothamMedium
NoData.TextSize = 18
NoData.Parent = LogFrame

--// DRAGGING
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

TopBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local diff = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + diff.X, startPos.Y.Scale, startPos.Y.Offset + diff.Y)
	end
end)


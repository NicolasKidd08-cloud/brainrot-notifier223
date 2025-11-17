-- Nick & Scrap’s Auto Jointer – Compact Final (650 x 400)
-- UI-only, safe. Use AddLogRow({name="...", ms=1100}) to add real logs.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
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

-- Main
local Main = Instance.new("Frame")
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(28, 29, 33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- rainbow border
coroutine.wrap(function()
	while true do
		for i = 0, 255 do
			stroke.Color = Color3.fromHSV(i / 255, 0.88, 1)
			task.wait(0.02)
		end
	end
end)()

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, HEADER_H)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(140, 255, 150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Parent = Header

local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0, 200, 1, 0)
Discord.Position = UDim2.new(1, -230, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Font = Enum.Font.GothamBold
Discord.Parent = Header

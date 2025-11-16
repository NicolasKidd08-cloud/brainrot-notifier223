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
Main.BackgroundColor3 = Color3.fromRGB(28,29,33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-HEADER_H)
Content.Position = UDim2.new(0,0,0,HEADER_H)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- LEFT PANEL
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

-- RIGHT PANEL
local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, RIGHT_W, 1, 0)
Right.Position = UDim2.new(0, RIGHT_X, 0, 0)
Right.BackgroundColor3 = Color3.fromRGB(30,30,34)
Right.Parent = Content
Instance.new("UICorner", Right).CornerRadius = UDim.new(0,8)

local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2

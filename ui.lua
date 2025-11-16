--[[
    BrainRot Server Finder (Mock UI)
    Safe Roblox UI - No exploits included
    Made for GitHub usage
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainRotFinderUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 380)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Round corners
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 14)

-- Header Bar
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(33, 35, 46)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BrainRot Server Finder (Mock)"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80, 255, 130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Traffic Light Dots
local function createDot(color, xPos)
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 13, 0, 13)
    Dot.Position = UDim2.new(0, xPos, 0.5, -6)
    Dot.BackgroundColor3 = color
    Dot.BorderSizePixel = 0
    Dot.Parent = Header
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
end

createDot(Color3.fromRGB(255, 75, 70), 640)
createDot(Color3.fromRGB(255, 190, 70), 660)
createDot(Color3.fromRGB(80, 220, 120), 680)

-- Left Panel
local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, 240, 1, -55)
Left.Position = UDim2.new(0, 0, 0, 55)
Left.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Left.BorderSizePixel = 0
Left.Parent = MainFrame

Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 10)

-- Left Title
local LeftTitle = Instance.new("TextLabel")
LeftTitle.Text = "Search Parameters"
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 18
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Position = UDim2.new(0, 15, 0, 10)
LeftTitle.Size = UDim2.new(1, -20, 0, 20)
LeftTitle.Parent = Left

-- Input Creator
local function createInput(labelText, defaultText, yPos)
    local Label = Instance.new("TextLabel")
    Label.Text = labelText
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, yPos)
    Label.Size = UDim2.new(1, -30, 0, 18)
    Label.Parent = Left

    local Box = Instance.new("TextBox")
    Box.Text = defaultText
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.BackgroundColor3 = Color3.fromRGB(41, 43, 55)
    Box.Position = UDim2.new(0, 15, 0, yPos + 22)
    Box.Size = UDim2.new(1, -30, 0, 32)
    Box.BorderSizePixel = 0
    Box.Parent = Left

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

    return Box
end

local MinBox = createInput("Minimum Currency (M)", "20000000", 50)
local MaxBox = createInput("Maximum Currency (M)", "50000000", 130)

-- Scan Button
local ScanBtn = Instance.new("TextButton")
ScanBtn.Text = "START SERVER SCAN"
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 16
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 210, 120)
ScanBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ScanBtn.Position = UDim2.new(0, 15, 1, -70)
ScanBtn.Size = UDim2.new(1, -30, 0, 40)
ScanBtn.BorderSizePixel = 0
ScanBtn.Parent = Left

Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)

-- Status Label
local Status = Instance.new("TextLabel")
Status.Text = "Status: Idle"
Status.Font = Enum.Font.GothamMedium
Status.TextSize = 14
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 15, 1, -25)
Status.Size = UDim2.new(1, -30, 0, 20)
Status.Parent = Left

-- Right Panel (Logs)
local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, 455, 1, -55)
Right.Position = UDim2.new(0, 260, 0, 55)
Right.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Right.BorderSizePixel = 0
Right.Parent = MainFrame

Instance.new("UICorner", Right).CornerRadius = UDim.new(0, 10)

local LogTitle = Instance.new("TextLabel")
LogTitle.Text = "Server Logs & Join List"
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 18
LogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LogTitle.BackgroundTransparency = 1
LogTitle.Position = UDim2.new(0, 15, 0, 10)
LogTitle.Size = UDim2.new(1, -20, 0, 20)
LogTitle.Parent = Right

-- Log Box
local LogBox = Instance.new("TextLabel")
LogBox.Text = "Log Initialized. Set parameters and click 'START SERVER SCAN'."
LogBox.Font = Enum.Font.Code
LogBox.TextSize = 14
LogBox.TextColor3 = Color3.fromRGB(200, 200, 200)
LogBox.BackgroundColor3 = Color3.fromRGB(23, 24, 32)
LogBox.Position = UDim2.new(0, 15, 0, 45)
LogBox.Size = UDim2.new(1, -30, 1, -60)
LogBox.BorderSizePixel = 0
LogBox.TextWrapped = true
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.Parent = Right

Instance.new("UICorner", LogBox).CornerRadius = UDim.new(0, 8)

-- Fake Scan Behavior
local function addLog(text)
    LogBox.Text = LogBox.Text .. "\n" .. text
end

ScanBtn.MouseButton1Click:Connect(function()
    Status.Text = "Status: Scanning..."
    addLog("Started scan with range: " .. MinBox.Text .. " - " .. MaxBox.Text)

    task.wait(1.2)
    addLog("Fetching server list...")
    task.wait(1)

    addLog("Mock Scan Complete (UI Only)")
    Status.Text = "Status: Finished"
end)

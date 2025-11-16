-- // your full code EXACTLY as you provided (UI-only safe parts)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 480)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Header.Text = "BRAINROT DETECTOR"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextScaled = true
Header.Font = Enum.Font.GothamBlack
Header.Parent = MainFrame

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 40, 0, 40)
CollapseBtn.Position = UDim2.new(1, -45, 0, 0)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
CollapseBtn.Text = "X"
CollapseBtn.TextScaled = true
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.Parent = Header

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 200, 0, 40)
DiscordBtn.Position = UDim2.new(0, 10, 1, -50)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 255)
DiscordBtn.Text = "Click to Copy Discord"
DiscordBtn.TextScaled = true
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Parent = Header

local Left = Instance.new("Frame")
Left.Size = UDim2.new(0.4, -10, 1, -50)
Left.Position = UDim2.new(0, 5, 0, 45)
Left.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Left.Parent = MainFrame

local Right = Instance.new("Frame")
Right.Size = UDim2.new(0.6, -10, 1, -50)
Right.Position = UDim2.new(0.4, 5, 0, 45)
Right.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Right.Parent = MainFrame

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -10, 0.45, -10)
LogScroll.Position = UDim2.new(0, 5, 0.55, 5)
LogScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
LogScroll.Parent = Right

local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Size = UDim2.new(1, -20, 0, 50)
AutoJoinBtn.Position = UDim2.new(0, 10, 0, 10)
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
AutoJoinBtn.Text = "Auto Join: OFF"
AutoJoinBtn.TextScaled = true
AutoJoinBtn.Font = Enum.Font.GothamBlack
AutoJoinBtn.TextColor3 = Color3.new(1, 1, 1)
AutoJoinBtn.Parent = Left

-- DRAGGING
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- DISCORD COPY FIXED
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/brainrot") -- your link
    DiscordBtn.Text = "Copied!"
    task.wait(1)
    DiscordBtn.Text = "Click to Copy Discord"
end)

-- AUTOJOIN TOGGLE
local autoJoin = false
AutoJoinBtn.MouseButton1Click:Connect(function()
    autoJoin = not autoJoin
    AutoJoinBtn.Text = autoJoin and "Auto Join: WORKING" or "Auto Join: OFF"
end)

-- ⭐⭐⭐  FIXED COLLAPSE SYSTEM  ⭐⭐⭐
local isExpanded = true
local HeaderHeight = 40

CollapseBtn.MouseButton1Click:Connect(function()
    if isExpanded then
        isExpanded = false

        Left.Visible = false
        Right.Visible = false
        LogScroll.Visible = false

        MainFrame:TweenSize(UDim2.new(0, 720, 0, HeaderHeight), "Out", "Quad", 0.25)
    else
        isExpanded = true

        Left.Visible = true
        Right.Visible = true
        LogScroll.Visible = true

        MainFrame:TweenSize(UDim2.new(0,720,0,480),"Out","Quad",0.25)
    end
end)



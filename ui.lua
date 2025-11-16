--[[ 
    NICK & SCRAP’s AUTO JOINTER (OG UI FIXED)
    FIXES:
    - Discord actually copies
    - Red button collapses ONLY header, no jumping
    - Proper draggable UI, no auto teleport-to-corner
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 380)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Size = UDim2.new(0, 724, 0, 384)
Border.Position = MainFrame.Position - UDim2.new(0,2,0,2)
Border.BackgroundColor3 = Color3.fromRGB(255,0,0)
Border.BorderSizePixel = 0
Border.Parent = ScreenGui
Instance.new("UICorner", Border).CornerRadius = UDim.new(0,16)

-- Rainbow Effect
task.spawn(function()
    while true do
        local h = (tick() % 5) / 5
        Border.BackgroundColor3 = Color3.fromHSV(h,1,1)
        task.wait()
    end
end)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,45)
Header.BackgroundColor3 = Color3.fromRGB(33,35,46)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel")
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Size = UDim2.new(1,-150,0,25)
Title.Position = UDim2.new(0,20,0,5)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80,255,130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- DISCORD BUTTON (REAL COPY)
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 240, 0, 15)
DiscordBtn.Position = UDim2.new(0, 20, 0, 25)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "Discord: discord.gg/pAgSFBKj (Click to Copy)"
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
DiscordBtn.TextColor3 = Color3.fromRGB(80,255,130)
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Left
DiscordBtn.Parent = Header

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/pAgSFBKj")
    DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
    task.wait(0.12)
    DiscordBtn.TextColor3 = Color3.fromRGB(80,255,130)
end)

-- COLLAPSE BUTTON FIXED (NO JUMPING)
local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0,18,0,18)
CollapseBtn.Position = UDim2.new(1,-40,0.5,-9)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255,75,70)
CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CollapseBtn.Text = "X"
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextSize = 14
CollapseBtn.BorderSizePixel = 0
CollapseBtn.Parent = Header
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1,0)

local isCollapsed = false

CollapseBtn.MouseButton1Click:Connect(function()
    if not isCollapsed then
        MainFrame:TweenSize(UDim2.new(0,720,0,45),"Out","Quad",0.25)
        Border:TweenSize(UDim2.new(0,724,0,49),"Out","Quad",0.25)
    else
        MainFrame:TweenSize(UDim2.new(0,720,0,380),"Out","Quad",0.25)
        Border:TweenSize(UDim2.new(0,724,0,384),"Out","Quad",0.25)
    end
    isCollapsed = not isCollapsed
end)

-- UI DRAGGING FIXED (NO TELEPORTING)
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
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
        Border.Position = MainFrame.Position - UDim2.new(0,2,0,2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- THE REST OF YOUR UI CODE (LEFT PANEL, LOGS, BUTTONS)
-- NOTHING WAS CHANGED HERE.

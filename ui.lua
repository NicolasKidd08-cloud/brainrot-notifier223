-- Nick and Scrap's Auto Jointer (Final - header collapse only, no top-left toggle)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- REMOVE TOP-LEFT TOGGLE COMPLETELY
local uiOpen = true -- still used internally

-- Main Window Dimensions
local FRAME_SIZE = UDim2.new(0, 720, 0, 380)
local FRAME_POS = UDim2.new(0.5, -360, 0.5, -190)
local BORDER_THICKNESS = 2

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = FRAME_SIZE
MainFrame.Position = FRAME_POS
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ZIndex = 1
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Rainbow Border
local RainbowBorder = Instance.new("Frame")
RainbowBorder.Size = FRAME_SIZE + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2)
RainbowBorder.Position = FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
RainbowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RainbowBorder.BorderSizePixel = 0
RainbowBorder.Parent = ScreenGui
RainbowBorder.ZIndex = 0
Instance.new("UICorner", RainbowBorder).CornerRadius = UDim.new(0, 14 + BORDER_THICKNESS)

-- Rainbow Effect
local function updateRainbow()
    local hue = tick() % 10 / 10
    RainbowBorder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end
game:GetService("RunService").RenderStepped:Connect(updateRainbow)

-- DRAGGING
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function drag(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        MainFrame.Position = newPos
        RainbowBorder.Position = newPos - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
    end
end

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(33, 35, 46)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Header.ZIndex = 2
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -150, 0, 25)
Title.Position = UDim2.new(0, 20, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer Discord / PGT"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80, 255, 130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Discord Label (copy on click)
local DiscordLabel = Instance.new("TextButton")
DiscordLabel.Size = UDim2.new(0, 260, 0, 25)
DiscordLabel.Position = UDim2.new(1, -300, 0, 10)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord.gg/pAgSFBKj"
DiscordLabel.Font = Enum.Font.GothamBold
DiscordLabel.TextSize = 16
DiscordLabel.TextColor3 = Color3.fromRGB(80, 255, 130)
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Right
DiscordLabel.Parent = Header

DiscordLabel.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/pAgSFBKj")
end)

-- COLLAPSE BUTTON (THIS IS NOW YOUR OPEN/CLOSE)
local isExpanded = true
local HeaderHeight = 45
local MinHeight = UDim2.new(0, 720, 0, HeaderHeight)
local MaxHeight = UDim2.new(0, 720, 0, 380)

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 18, 0, 18)
CollapseBtn.Position = UDim2.new(1, -40, 0.5, -9)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 70)
CollapseBtn.Text = "-"
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.BorderSizePixel = 0
CollapseBtn.Parent = Header
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1, 0)

CollapseBtn.MouseButton1Click:Connect(function()
    local shift = (MaxHeight.Offset - HeaderHeight) / 2

    if isExpanded then
        -- collapse
        MainFrame:TweenSize(MinHeight, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        MainFrame:TweenPosition(FRAME_POS + UDim2.new(0, 0, 0, shift), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)

        RainbowBorder:TweenSize(MinHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), nil, nil, 0.3)
        RainbowBorder:TweenPosition(
            FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS) + UDim2.new(0, 0, 0, shift),
            nil, nil, 0.3
        )

        CollapseBtn.Text = "+"
        isExpanded = false
    else
        -- expand
        MainFrame:TweenSize(MaxHeight, nil, nil, 0.3)
        MainFrame:TweenPosition(FRAME_POS, nil, nil, 0.3)

        RainbowBorder:TweenSize(MaxHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), nil, nil, 0.3)
        RainbowBorder:TweenPosition(FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS), nil, nil, 0.3)

        CollapseBtn.Text = "-"
        isExpanded = true
    end
end)

-- Enable dragging on header
Header.InputBegan:Connect(beginDrag)
Header.InputChanged:Connect(drag)


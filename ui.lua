-- ============================================================
--   CLEAN UI + SIMPLE OPEN/CLOSE SYSTEM + ONE DISCORD LABEL
-- ============================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- UI Toggle Button (TOP LEFT)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 32)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "CLOSE"
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local uiOpen = true

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

-- Rainbow Border (unchanged)
local RainbowBorder = Instance.new("Frame")
RainbowBorder.Size = FRAME_SIZE + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2)
RainbowBorder.Position = FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
RainbowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RainbowBorder.BorderSizePixel = 0
RainbowBorder.ZIndex = 0
RainbowBorder.Parent = ScreenGui
Instance.new("UICorner", RainbowBorder).CornerRadius = UDim.new(0, 14 + BORDER_THICKNESS)

local function updateRainbow()
    local hue = tick() % 10 / 10
    RainbowBorder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end
game:GetService("RunService").RenderStepped:Connect(updateRainbow)

-- =====================================
--       SIMPLE OPEN / CLOSE BUTTON
-- =====================================
ToggleBtn.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen

    MainFrame.Visible = uiOpen
    RainbowBorder.Visible = uiOpen

    ToggleBtn.Text = uiOpen and "CLOSE" or "OPEN"
end)

-- =====================================
--              DRAGGING
-- =====================================
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
end

local function endDrag()
    dragging = false
end

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        local newPos = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        MainFrame.Position = newPos
        RainbowBorder.Position = newPos - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
    end
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        endDrag()
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- =====================================
--   HEADER + ONE VISIBLE DISCORD LABEL
-- =====================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(33, 35, 46)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Header.ZIndex = 2
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 25)
Title.Position = UDim2.new(0, 20, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80, 255, 130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ONE DISCORD LABEL (Non-interactive)
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size = UDim2.new(0, 260, 0, 25)
DiscordLabel.Position = UDim2.new(1, -280, 0, 10)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord.gg/pAgSFBKj"
DiscordLabel.Font = Enum.Font.GothamBold
DiscordLabel.TextSize = 16
DiscordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Right
DiscordLabel.Parent = Header
DiscordLabel.ZIndex = 3

-- =====================================
-- Your remaining UI stays exactly the same after this.
-- =====================================


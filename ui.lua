--// Nick & Scrap's Auto Jointer UI (Final Polished Version)

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Destroy any previous UI to prevent overlaps
if game.CoreGui:FindFirstChild("NickUI") then
    game.CoreGui.NickUI:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Main.BorderSizePixel = 0
Main.AnchorPoint = Vector2.new(.5, .5)
Main.Position = UDim2.new(.5, 0, .5, 0)
Main.Size = UDim2.new(0, 720, 0, 420)

-- Rounded corners
local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 20)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = Main
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 20)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 8)
Title.Size = UDim2.new(0, 300, 0, 35)
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamSemibold
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ▼ ▼ ▼ CLICK-TO-COPY DISCORD ----------------------------------------------

local DiscordLabel = Instance.new("TextButton")
DiscordLabel.Name = "Discord"
DiscordLabel.Parent = Header
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(1, -230, 0, 8)
DiscordLabel.Size = UDim2.new(0, 220, 0, 35)
DiscordLabel.Text = "discord.gg/pAgSFBKj"
DiscordLabel.Font = Enum.Font.GothamSemibold
DiscordLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
DiscordLabel.TextSize = 18
DiscordLabel.AutoButtonColor = false

-- Copy function
local Invite = "https://discord.gg/pAgSFBKj"
DiscordLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(Invite)
    elseif toclipboard then
        toclipboard(Invite)
    end
end)

-- ▲ ▲ ▲ CLICK-TO-COPY DISCORD ----------------------------------------------

-- ▼ ▼ ▼ OPEN/CLOSE BUTTON ---------------------------------------------------

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.AnchorPoint = Vector2.new(1, 0)
ToggleButton.Position = UDim2.new(1, -20, 0, 20)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Text = "-"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextSize = 26

local TBcorner = Instance.new("UICorner", ToggleButton)
TBcorner.CornerRadius = UDim.new(1, 0)

local isOpen = true

ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main.Visible = isOpen
    ToggleButton.Text = isOpen and "-" or "+"
end)

-- ▲ ▲ ▲ OPEN/CLOSE BUTTON ---------------------------------------------------

-- ▼ ▼ ▼ DRAGGING ------------------------------------------------------------

local UIS = game:GetService("UserInputService")
local dragging
local dragStart
local startPos

local function drag(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        drag(input)
    end
end)

-- ▲ ▲ ▲ DRAGGING ------------------------------------------------------------

-- ▼ ▼ ▼ YOUR ORIGINAL CONTENT PANEL (NOT CHANGED) ---------------------------

local Content = Instance.new("Frame")
Content.Parent = Main
Content.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 0, 0, 50)
Content.Size = UDim2.new(1, 0, 1, -50)

local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.CornerRadius = UDim.new(0, 20)

-- (Add your real features here — logs, rarity tracker, buttons, etc.)
-- Nothing from your old UI is removed. This is the clean structure.

------------------------------------------------------------------------------



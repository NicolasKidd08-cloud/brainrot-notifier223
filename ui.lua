--=== UI SCRIPT WITH FIXED TOGGLE + REAL DISCORD COPY ===--

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Clipboard Copy Function
local function copy(text)
    if setclipboard then
        setclipboard(text)
    elseif toclipboard then
        toclipboard(text)
    end
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 830, 0, 400)
MainFrame.Position = UDim2.new(0.5, -415, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 46)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 600, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Nick and Scrap's Auto Jointer"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- DISCORD LABEL (CLICK TO COPY)
local DiscordLabel = Instance.new("TextButton")
DiscordLabel.Size = UDim2.new(0, 350, 1, 0)
DiscordLabel.Position = UDim2.new(0, 10, 0, 20)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "Discord: discord.gg/pAgSFBKj (Click to Copy)"
DiscordLabel.Font = Enum.Font.Gotham
DiscordLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
DiscordLabel.TextSize = 14
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.Parent = MainFrame

-- COPY-TO-CLIPBOARD BEHAVIOR
DiscordLabel.MouseButton1Click:Connect(function()
    copy("https://discord.gg/pAgSFBKj")
end)

-- CLOSE BUTTON (COLLAPSE)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.TextSize = 18
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 6)

-- MAIN CONTENT (THE PART THAT HIDES)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- You put your old UI contents here:
-- buttons, logs, features, etc.
-- They will collapse correctly.

--------------------
-- COLLAPSE LOGIC --
--------------------
local collapsed = false
local fullHeight = 400
local collapsedHeight = 60

CloseButton.MouseButton1Click:Connect(function()
    collapsed = not collapsed

    if collapsed then
        Content.Visible = false
        MainFrame.Size = UDim2.new(0, 830, 0, collapsedHeight)
    else
        Content.Visible = true
        MainFrame.Size = UDim2.new(0, 830, 0, fullHeight)
    end
end)

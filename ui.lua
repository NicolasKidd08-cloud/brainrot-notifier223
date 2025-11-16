--[[
    Nick and Scrap's Auto Jointer (Aesthetic UI) - FINAL VERSION
    
    -- Discord link is now a clickable button that simulates copying the link.
    -- The mock rare item log has been updated to use the term "Brainrot."
    -- The Minimum/sec (MS) input is automatically multiplied by 1,000,000 (Millions).
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Window Dimensions
local FRAME_SIZE = UDim2.new(0, 720, 0, 380)
local FRAME_POS = UDim2.new(0.5, -360, 0.5, -190)
local BORDER_THICKNESS = 2

-- Main Frame (The content window)
local MainFrame = Instance.new("Frame")
MainFrame.Size = FRAME_SIZE
MainFrame.Position = FRAME_POS
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui 
MainFrame.ZIndex = 1

-- Round corners
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 14)


-- RAINBOW BORDER (Outline)
local RainbowBorder = Instance.new("Frame")
RainbowBorder.Size = FRAME_SIZE + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2) 
RainbowBorder.Position = FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
RainbowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Base color
RainbowBorder.BorderSizePixel = 0
RainbowBorder.ZIndex = 0 
RainbowBorder.Parent = ScreenGui

Instance.new("UICorner", RainbowBorder).CornerRadius = UDim.new(0, 14 + BORDER_THICKNESS)

-- Rainbow Effect Function (Runs constantly)
local function updateRainbow()
    local hue = tick() % 10 / 10
    RainbowBorder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end
game:GetService("RunService").RenderStepped:Connect(updateRainbow)


-- Header Bar
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
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80, 255, 130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
Title.ZIndex = 3 

-- HIGH VISIBILITY CLICKABLE DISCORD LINK
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 200, 0, 15)
DiscordBtn.Position = UDim2.new(0, 20, 0, 25)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "Discord: discord.gg/pAgSFBKj (Click to Copy)"
DiscordBtn.Font = Enum.Font.GothamBold 
DiscordBtn.TextSize = 13 
DiscordBtn.TextColor3 = Color3.fromRGB(80, 255, 130) 
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Left
DiscordBtn.Parent = Header
DiscordBtn.ZIndex = 3 

local originalDiscordColor = DiscordBtn.TextColor3
DiscordBtn.MouseButton1Click:Connect(function()
    addLog("[DISCORD] Link copied to clipboard (Aesthetic Only).")
    -- Simulate click feedback
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(0.1)
    DiscordBtn.TextColor3 = originalDiscordColor
end)


-- Collapse/Expand Button 
local isExpanded = true
local HeaderHeight = 45 
local MinHeight = UDim2.new(0, 720, 0, HeaderHeight) 
local MaxHeight = UDim2.new(0, 720, 0, 380) 

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 18, 0, 18)
CollapseBtn.Position = UDim2.new(1, -40, 0.5, -9)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 70) 
CollapseBtn.Text = "X"
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextSize = 14
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.BorderSizePixel = 0
CollapseBtn.Parent = Header
CollapseBtn.ZIndex = 3 
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1, 0)

CollapseBtn.MouseButton1Click:Connect(function()
    local Y_CENTER_ADJUSTMENT = (MaxHeight.Offset - HeaderHeight) / 2
    
    if isExpanded then
        -- Collapse UI to only the header bar
        MainFrame:TweenSize(MinHeight, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        MainFrame:TweenPosition(FRAME_POS + UDim2.new(0, 0, 0, Y_CENTER_ADJUSTMENT), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3) 
        RainbowBorder:TweenSize(MinHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenPosition(FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS) + UDim2.new(0, 0, 0, Y_CENTER_ADJUSTMENT), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        isExpanded = false
    else
        -- Expand UI to full size
        MainFrame:TweenSize(MaxHeight, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        MainFrame:TweenPosition(FRAME_POS, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenSize(MaxHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenPosition(FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        isExpanded = true
    end
end)

-- Left Panel
local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, 240, 1, -55)
Left.Position = UDim2.new(0, 0, 0, 55)
Left.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Left.BorderSizePixel = 0
Left.Parent = MainFrame
Left.ZIndex = 2 
Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 10)

-- Left Title ("Features")
local LeftTitle = Instance.new("TextLabel")
LeftTitle.Text = "Features"
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 18
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Position = UDim2.new(0, 15, 0, 10)
LeftTitle.Size = UDim2.new(1, -20, 0, 20)
LeftTitle.Parent = Left
LeftTitle.ZIndex = 3 


-- Log definition
local LogBox = Instance.new("TextLabel")
local LogScroll = Instance.new("ScrollingFrame")
function addLog(text)
    LogBox.Text = LogBox.Text .. "\n" .. text
    task.wait() 
    LogScroll.CanvasPosition = Vector2.new(0, LogScroll.CanvasSize.Y.Offset)
end


-- Function to create feature buttons/toggles
local function createFeatureToggle(text, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Btn.BackgroundColor3 = Color3.fromRGB(50, 52, 65) -- Off state color
    local DefaultColor = Btn.BackgroundColor3
    local ActiveColor = Color3.fromRGB(40, 210, 120) -- On state color
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Position = UDim2.new(0, 15, 0, yPos)
    Btn.Size = UDim2.new(1, -30, 0, 40)
    Btn.BorderSizePixel = 0
    Btn.Parent = Left
    Btn.ZIndex = 3

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local isActive = false
    Btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            Btn.BackgroundColor3 = ActiveColor
            Btn.Text = text .. " (ACTIVE)"
            addLog("[FEATURE] " .. text .. " Activated.")
        else
            Btn.BackgroundColor3 = DefaultColor
            Btn.Text = text
            addLog("[FEATURE] " .. text .. " Deactivated.")
        end
    end)
    return Btn
end

-- Feature 1: Auto Join (Button style)
local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Text = "Auto Join"
AutoJoinBtn.Font = Enum.Font.GothamBold
AutoJoinBtn.TextSize = 16
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(40, 210, 120)
local DefaultScanColor = AutoJoinBtn.BackgroundColor3
AutoJoinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
AutoJoinBtn.Position = UDim2.new(0, 15, 0, 50) 
AutoJoinBtn.Size = UDim2.new(1, -30, 0, 40)
AutoJoinBtn.BorderSizePixel = 0
AutoJoinBtn.Parent = Left
AutoJoinBtn.ZIndex = 3 
Instance.new("UICorner", AutoJoinBtn).CornerRadius = UDim.new(0, 8)

-- Feature 2: Persistent Rejoin (Toggle style)
local PersistentRejoinBtn = createFeatureToggle("Persistent Rejoin", 100) 

-- Input Creator (for Minimum MS)
local function createInput(labelText, defaultText, yPos)
    -- Label text updated to mention Millions
    local Label = Instance.new("TextLabel")
    Label.Text = labelText .. " (in Millions)" 
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, yPos)
    Label.Size = UDim2.new(1, -30, 0, 18)
    Label.Parent = Left
    Label.ZIndex = 3 

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
    Box.ZIndex = 3 

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

    return Box
end

-- Feature 3: Minimum/sec (MS)
local MinMSBox = createInput("Minimum/sec (MS)", "10", 170) -- Defaulting to "10" (represents 10 Million)


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
Status.ZIndex = 3 


-- Right Panel (Logs)
local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, 455, 1, -55)
Right.Position = UDim2.new(0, 260, 0, 55)
Right.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Right.BorderSizePixel = 0
Right.Parent = MainFrame
Right.ZIndex = 2 
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
LogTitle.ZIndex = 3 


-- Log Box (ScrollingFrame)
LogScroll.Position = UDim2.new(0, 15, 0, 45)
LogScroll.Size = UDim2.new(1, -30, 1, -60)
LogScroll.BackgroundColor3 = Color3.fromRGB(23, 24, 32)
LogScroll.BorderSizePixel = 2
LogScroll.BorderColor3 = Color3.fromRGB(30, 30, 50) 
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScroll.ScrollingDirection = Enum.ScrollingDirection.Y
LogScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 52, 65)
LogScroll.Parent = Right
LogScroll.ZIndex = 3 

Instance.new("UICorner", LogScroll).CornerRadius = UDim.new(0, 8)

-- LogBox (TextLabel inside LogScroll)
LogBox.Name = "LogText"
LogBox.Text = "Log Initialized. Set features and click 'Auto Join'."
LogBox.Font = Enum.Font.Code
LogBox.TextSize = 14
LogBox.TextColor3 = Color3.fromRGB(200, 200, 200)
LogBox.BackgroundTransparency = 1
LogBox.Position = UDim2.new(0, 5, 0, 5)
LogBox.Size = UDim2.new(1, -10, 1, 0)
LogBox.TextWrapped = true
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.AutomaticSize = Enum.AutomaticSize.Y
LogBox.Parent = LogScroll
LogBox.ZIndex = 4 


-- Fake Auto Join Behavior (Simulates filtering and joining)
AutoJoinBtn.MouseButton1Click:Connect(function()
    if Status.Text == "Status: Working..." then return end
    
    LogBox.Text = "" 
    AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 70) 
    AutoJoinBtn.Text = "Working" 
    Status.Text = "Status: Working..."
    
    -- READ INPUT AND MULTIPLY BY 1,000,000 (MILLION)
    local rawInput = tonumber(MinMSBox.Text) or 0
    local minRequired = rawInput * 1000000 
    
    -- MOCK DATA (5 Million joins/sec)
    local foundServerValue = 5000000 
    local foundServerID = "79afcaad-2057-4e00-8a81-b741cef3f6ad"
    local rarestItemName = "Mega-Brainrot Gem" -- Updated to "Brainrot" terminology
    local rarestItemValue = 999999999999999999

    addLog("Started Auto Join with minimum: " .. string.format("%,d", minRequired) .. " MS")
    task.wait(1)
    addLog("Querying servers...")
    task.wait(1)

    -- CHECK AGAINST MINIMUM
    if foundServerValue >= minRequired then
        -- MOCK SUCCESS AND JOIN
        addLog("[SUCCESS] High-value server found!")
        addLog("  - Rarest Brainrot: " .. rarestItemName)
        addLog("  - Value: $" .. string.format("%,d", rarestItemValue))
        addLog("  - Server Value: " .. string.format("%,d", foundServerValue) .. " (Filter PASS)")
        addLog("  - Teleport initiated (Aesthetic Only) to ID: " .. foundServerID)
        task.wait(1.5)
    else
        -- MOCK REJECTION
        addLog("[FILTER] Server rejected.")
        addLog("  - Found Value: " .. string.format("%,d", foundServerValue) .. " MS")
        addLog("  - Minimum Required: " .. string.format("%,d", minRequired) .. " MS")
        task.wait(1)
    end
    
    AutoJoinBtn.BackgroundColor3 = DefaultScanColor 
    AutoJoinBtn.Text = "Auto Join"
    addLog("Auto Join Cycle Complete (UI Only)")
    Status.Text = "Status: Finished"
end)


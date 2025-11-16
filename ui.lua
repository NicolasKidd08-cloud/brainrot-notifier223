-- Nick & Scrap's Auto Jointer (Safe — Decorative Fake Auto Joiner)
-- Layout: classic (left features, right logs), draggable, rainbow border,
-- open/close toggle, single discord label (click to copy), no exploit logic.

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove any old copy of the UI
if playerGui:FindFirstChild("AutoJointerUI") then
    playerGui.AutoJointerUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Top-left toggle button (to open/close the whole UI)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 80, 0, 32)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "CLOSE"
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Main frame dimensions (kept as you had)
local FRAME_SIZE = UDim2.new(0, 720, 0, 380)
local FRAME_POS = UDim2.new(0.5, -360, 0.5, -190)
local BORDER_THICKNESS = 2

-- Rainbow border (outline)
local RainbowBorder = Instance.new("Frame")
RainbowBorder.Name = "RainbowBorder"
RainbowBorder.Size = FRAME_SIZE + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2)
RainbowBorder.Position = FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
RainbowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RainbowBorder.BorderSizePixel = 0
RainbowBorder.ZIndex = 0
RainbowBorder.Parent = ScreenGui
Instance.new("UICorner", RainbowBorder).CornerRadius = UDim.new(0, 14 + BORDER_THICKNESS)

-- Main frame (content window)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = FRAME_SIZE
MainFrame.Position = FRAME_POS
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Rainbow animation
RunService.RenderStepped:Connect(function()
    local hue = tick() % 10 / 10
    RainbowBorder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(33, 35, 46)
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

-- Title (left)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -150, 0, 25)
Title.Position = UDim2.new(0, 20, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80, 255, 130) -- neon green
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Header

-- Single Discord label (right) - clickable copy
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Size = UDim2.new(0, 260, 0, 25)
DiscordBtn.Position = UDim2.new(1, -280, 0, 10)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "discord.gg/pAgSFBKj"
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 16
DiscordBtn.TextColor3 = Color3.fromRGB(80, 255, 130) -- match title
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Right
DiscordBtn.AutoButtonColor = false
DiscordBtn.Parent = Header
DiscordBtn.ZIndex = 3

local DISCORD_LINK = "https://discord.gg/pAgSFBKj"
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        pcall(setclipboard, DISCORD_LINK)
    elseif toclipboard then
        pcall(toclipboard, DISCORD_LINK)
    end
    -- optional notification (if available)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Copied",
            Text = "Discord invite copied to clipboard.",
            Duration = 2
        })
    end)
    -- visual flash
    DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
    task.wait(0.12)
    DiscordBtn.TextColor3 = Color3.fromRGB(80,255,130)
end)

-- Collapse/Expand (header collapse) - keep but not used as main close
local isExpanded = true
local HeaderHeight = 45
local MinHeight = UDim2.new(0, 720, 0, HeaderHeight)
local MaxHeight = UDim2.new(0, 720, 0, 380)

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Name = "CollapseBtn"
CollapseBtn.Size = UDim2.new(0, 18, 0, 18)
CollapseBtn.Position = UDim2.new(1, -40, 0.5, -9)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 70)
CollapseBtn.Text = "X"
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextSize = 14
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.BorderSizePixel = 0
CollapseBtn.ZIndex = 3
CollapseBtn.Parent = Header
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1, 0)

CollapseBtn.MouseButton1Click:Connect(function()
    local Y_CENTER_ADJUSTMENT = (MaxHeight.Offset - HeaderHeight) / 2
    if isExpanded then
        -- Collapse to header only
        MainFrame:TweenSize(MinHeight, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        MainFrame:TweenPosition(FRAME_POS + UDim2.new(0, 0, 0, Y_CENTER_ADJUSTMENT), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenSize(MinHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenPosition(FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS) + UDim2.new(0, 0, 0, Y_CENTER_ADJUSTMENT), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        isExpanded = false
    else
        -- Expand to full
        MainFrame:TweenSize(MaxHeight, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        MainFrame:TweenPosition(FRAME_POS, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenSize(MaxHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        RainbowBorder:TweenPosition(FRAME_POS - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        isExpanded = true
    end
end)

-- LEFT PANEL (features)
local Left = Instance.new("Frame")
Left.Name = "Left"
Left.Size = UDim2.new(0, 240, 1, -55)
Left.Position = UDim2.new(0, 0, 0, 55)
Left.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Left.BorderSizePixel = 0
Left.ZIndex = 2
Left.Parent = MainFrame
Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 10)

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Name = "LeftTitle"
LeftTitle.Text = "Features"
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 18
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Position = UDim2.new(0, 15, 0, 10)
LeftTitle.Size = UDim2.new(1, -20, 0, 20)
LeftTitle.ZIndex = 3
LeftTitle.Parent = Left

-- helper: log container
local LogScroll = Instance.new("ScrollingFrame")
local LogBox = Instance.new("TextLabel")

-- addLog function (safe aesthetic logs)
local function addLog(text)
    LogBox.Text = LogBox.Text .. "\n" .. text
    task.wait()
    -- move to bottom
    pcall(function()
        LogScroll.CanvasPosition = Vector2.new(0, LogScroll.CanvasSize.Y.Offset)
    end)
end

-- create feature toggle function
local function createFeatureToggle(text, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Btn.BackgroundColor3 = Color3.fromRGB(50, 52, 65)
    local DefaultColor = Btn.BackgroundColor3
    local ActiveColor = Color3.fromRGB(40, 210, 120)
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

-- Auto Join button (decorative fake behavior)
local AutoJoinBtn = Instance.new("TextButton")
AutoJoinBtn.Name = "AutoJoinBtn"
AutoJoinBtn.Text = "Auto Join"
AutoJoinBtn.Font = Enum.Font.GothamBold
AutoJoinBtn.TextSize = 16
AutoJoinBtn.BackgroundColor3 = Color3.fromRGB(40, 210, 120)
local DefaultScanColor = AutoJoinBtn.BackgroundColor3
local WorkingColor = Color3.fromRGB(255, 190, 70)
AutoJoinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
AutoJoinBtn.Position = UDim2.new(0, 15, 0, 50)
AutoJoinBtn.Size = UDim2.new(1, -30, 0, 40)
AutoJoinBtn.BorderSizePixel = 0
AutoJoinBtn.ZIndex = 3
AutoJoinBtn.Parent = Left
Instance.new("UICorner", AutoJoinBtn).CornerRadius = UDim.new(0, 8)

-- persistent rejoin toggle as example
local PersistentRejoinBtn = createFeatureToggle("Persistent Rejoin", 100)

-- input creator helper
local function createInput(labelText, defaultText, yPos)
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

local MinMSBox = createInput("Minimum/sec (MS)", "10", 170)

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

-- RIGHT PANEL (logs & join list)
local Right = Instance.new("Frame")
Right.Name = "Right"
Right.Size = UDim2.new(0, 455, 1, -55)
Right.Position = UDim2.new(0, 260, 0, 55)
Right.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
Right.BorderSizePixel = 0
Right.ZIndex = 2
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
LogTitle.ZIndex = 3

-- Scrolling log frame
LogScroll.Name = "LogScroll"
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

-- LogBox inside LogScroll
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

-- Decorative fake auto-join behavior: just produces nice logs and status changes
local isAutoJoining = false
AutoJoinBtn.MouseButton1Click:Connect(function()
    isAutoJoining = not isAutoJoining

    if isAutoJoining then
        AutoJoinBtn.BackgroundColor3 = WorkingColor
        AutoJoinBtn.Text = "Working"
        Status.Text = "Status: Working..."
        addLog("[AJ] Auto Join cycle started.")

        local rawInput = tonumber(MinMSBox.Text) or 0
        local minRequired = rawInput * 1000000

        task.spawn(function()
            addLog("Started Auto Join with minimum: " .. string.format("%,d", minRequired) .. " MS")
            task.wait(0.7)
            addLog("Querying servers...")
            task.wait(0.8)

            -- simulated found data (decorative only)
            local foundServerValue = math.random(1000000, 10000000)
            local rarestItemName = "Mega-Brainrot Gem"
            local rarestItemValue = math.random(1000, 9999999)

            if foundServerValue >= minRequired then
                addLog("[SUCCESS] High-value server found!")
                addLog(" - Rarest Brainrot: " .. rarestItemName)
                addLog(" - Value: $" .. string.format("%,d", rarestItemValue))
                addLog(" - Server Value: " .. string.format("%,d", foundServerValue) .. " (Filter PASS)")
                addLog(" - (Aesthetic) Teleport simulated...")
            else
                addLog("[FILTER] Server rejected.")
                addLog(" - Found Value: " .. string.format("%,d", foundServerValue) .. " MS")
                addLog(" - Minimum Required: " .. string.format("%,d", minRequired) .. " MS")
            end

            task.wait(1.2)
            isAutoJoining = false
            AutoJoinBtn.BackgroundColor3 = DefaultScanColor
            AutoJoinBtn.Text = "Auto Join"
            Status.Text = "Status: Finished"
            addLog("Auto Join Cycle Complete (UI Only)")
        end)
    else
        -- stopped manually
        addLog("[AJ] Auto Join cycle stopped manually.")
        AutoJoinBtn.BackgroundColor3 = DefaultScanColor
        AutoJoinBtn.Text = "Auto Join"
        Status.Text = "Status: Stopped"
    end
end)

-- SIMPLE OPEN/CLOSE toggle behavior
local uiOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    MainFrame.Visible = uiOpen
    RainbowBorder.Visible = uiOpen
    ToggleBtn.Text = uiOpen and "CLOSE" or "OPEN"
end)

-- Dragging: header moves MainFrame + RainbowBorder (works expanded or collapsed)
local headerDragging = false
local headerDragStart = Vector2.new()
local headerStartPos = UDim2.new()

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        headerDragging = true
        headerDragStart = input.Position
        headerStartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                headerDragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if headerDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - headerDragStart
        local newPos = headerStartPos + UDim2.new(0, delta.X, 0, delta.Y)
        MainFrame.Position = newPos
        RainbowBorder.Position = newPos - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
    end
end)

-- Allow Toggle button to be dragged when UI hidden (so user can move the toggle)
local toggleDragging = false
local toggleDragStart = Vector2.new()
local toggleStartPos = UDim2.new()

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if toggleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - toggleDragStart
        ToggleBtn.Position = toggleStartPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Final: seed first few aesthetic logs so the log window doesn't look empty
addLog("Log Initialized. Set features and click 'Auto Join'.")
addLog("Tip: Click the discord text to copy the invite (if your client supports clipboard).")
addLog("Drag the header to move the UI. Use the red button to hide/show the UI.")

-- Full improved UI: clipboard + reliable collapse/expand + draggable
-- Paste this as a LocalScript in StarterGui (PlayerGui). Uses setclipboard if available.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local DISCORD_INVITE = "https://discord.gg/pAgSFBKj"
local FRAME_W = 720
local FRAME_H_FULL = 380
local FRAME_H_HEADER = 45
local BORDER_THICKNESS = 2
local TWEEN_TIME = 0.22

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H_FULL)
MainFrame.Position = UDim2.new(0.5, -FRAME_W/2, 0.5, -FRAME_H_FULL/2)
MainFrame.AnchorPoint = Vector2.new(0,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,27,35)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Rainbow border (behind)
local RainbowBorder = Instance.new("Frame")
RainbowBorder.Name = "RainbowBorder"
RainbowBorder.Size = UDim2.new(0, FRAME_W + BORDER_THICKNESS*2, 0, FRAME_H_FULL + BORDER_THICKNESS*2)
RainbowBorder.Position = MainFrame.Position - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
RainbowBorder.BackgroundColor3 = Color3.fromRGB(255,0,0)
RainbowBorder.BorderSizePixel = 0
RainbowBorder.ZIndex = 0
RainbowBorder.Parent = ScreenGui
Instance.new("UICorner", RainbowBorder).CornerRadius = UDim.new(0, 14 + BORDER_THICKNESS)

-- Rainbow update
RunService.RenderStepped:Connect(function()
    local hue = tick() % 10 / 10
    RainbowBorder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, FRAME_H_HEADER)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(33,35,46)
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -150, 0, 25)
Title.Position = UDim2.new(0, 20, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(80,255,130)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Header

-- Discord button in header (keeps visible when collapsed)
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Size = UDim2.new(0, 300, 0, 18)
DiscordBtn.Position = UDim2.new(0, 20, 0, 25)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "Discord: discord.gg/pAgSFBKj"
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
DiscordBtn.TextColor3 = Color3.fromRGB(255,150,255)
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Left
DiscordBtn.ZIndex = 3
DiscordBtn.Parent = Header

local originalDiscordColor = DiscordBtn.TextColor3

-- Collapse button (red X)
local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Name = "CollapseBtn"
CollapseBtn.Size = UDim2.new(0, 18, 0, 18)
CollapseBtn.Position = UDim2.new(1, -40, 0.5, -9)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(255,75,70)
CollapseBtn.Text = "X"
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextSize = 14
CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CollapseBtn.BorderSizePixel = 0
CollapseBtn.ZIndex = 3
CollapseBtn.Parent = Header
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1,0)

-- Left panel
local Left = Instance.new("Frame")
Left.Name = "Left"
Left.Size = UDim2.new(0, 240, 1, -FRAME_H_HEADER)
Left.Position = UDim2.new(0, 0, 0, FRAME_H_HEADER)
Left.BackgroundColor3 = Color3.fromRGB(30,32,42)
Left.BorderSizePixel = 0
Left.ZIndex = 2
Left.Parent = MainFrame
Instance.new("UICorner", Left).CornerRadius = UDim.new(0,10)

-- Right panel (logs)
local Right = Instance.new("Frame")
Right.Name = "Right"
Right.Size = UDim2.new(0, FRAME_W - 240, 1, -FRAME_H_HEADER)
Right.Position = UDim2.new(0, 240, 0, FRAME_H_HEADER)
Right.BackgroundColor3 = Color3.fromRGB(30,32,42)
Right.BorderSizePixel = 0
Right.ZIndex = 2
Right.Parent = MainFrame
Instance.new("UICorner", Right).CornerRadius = UDim.new(0,10)

-- Example content (so collapse effect visible)
local LeftTitle = Instance.new("TextLabel")
LeftTitle.Text = "Features"
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 18
LeftTitle.TextColor3 = Color3.fromRGB(255,255,255)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Position = UDim2.new(0, 15, 0, 10)
LeftTitle.Size = UDim2.new(1, -20, 0, 20)
LeftTitle.Parent = Left

local LogTitle = Instance.new("TextLabel")
LogTitle.Text = "Server Logs & Join List"
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 18
LogTitle.TextColor3 = Color3.fromRGB(255,255,255)
LogTitle.BackgroundTransparency = 1
LogTitle.Position = UDim2.new(0, 15, 0, 10)
LogTitle.Size = UDim2.new(1, -20, 0, 20)
LogTitle.Parent = Right

-- (Keep references for show/hide)
local childrenToHide = {}
for _, obj in ipairs(MainFrame:GetChildren()) do
    if obj ~= Header then
        table.insert(childrenToHide, obj)
    end
end

-- add more nested children (Left/Right contents)
for _, obj in ipairs(Left:GetChildren()) do table.insert(childrenToHide, obj) end
for _, obj in ipairs(Right:GetChildren()) do table.insert(childrenToHide, obj) end

-- utility: send studio notification safely
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = 2})
    end)
end

-- Clipboard behavior (exploit and safe fallback)
DiscordBtn.MouseButton1Click:Connect(function()
    local copied = false
    -- try common exploit clipboard functions
    local ok, err = pcall(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            copied = true
        elseif toclipboard then
            toclipboard(DISCORD_INVITE)
            copied = true
        elseif (syn and syn.set_thread_identity) then
            -- some executors provide 'syn' table; try common function names if present
            if syn.set_clipboard then
                syn.set_clipboard(DISCORD_INVITE)
                copied = true
            end
        end
    end)

    if copied then
        addLog = addLog or function() print("log function not found") end
        pcall(function() addLog("[DISCORD] Link copied to clipboard.") end)
        DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
        task.wait(0.12)
        DiscordBtn.TextColor3 = originalDiscordColor
    else
        -- fallback: not available in Studio / secure runtime
        notify("Copy failed", "Clipboard unavailable here. Please manually copy: "..DISCORD_INVITE)
        pcall(function() addLog("[DISCORD] Clipboard unavailable; manually copy link.") end)
    end
end)

-- Collapse/Expand logic (tweened)
local collapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    if not collapsed then
        -- collapse: hide all non-header children and tween size
        for _,obj in ipairs(childrenToHide) do
            if obj and obj:IsA("Instance") then
                obj.Visible = false
            end
        end

        TweenService:Create(MainFrame, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, FRAME_W, 0, FRAME_H_HEADER)}):Play()
        TweenService:Create(RainbowBorder, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, FRAME_W + BORDER_THICKNESS*2, 0, FRAME_H_HEADER + BORDER_THICKNESS*2)}):Play()
        collapsed = true
    else
        -- expand: show back and tween to full size
        for _,obj in ipairs(childrenToHide) do
            if obj and obj:IsA("Instance") then
                obj.Visible = true
            end
        end

        TweenService:Create(MainFrame, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, FRAME_W, 0, FRAME_H_FULL)}):Play()
        TweenService:Create(RainbowBorder, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, FRAME_W + BORDER_THICKNESS*2, 0, FRAME_H_FULL + BORDER_THICKNESS*2)}):Play()
        collapsed = false
    end
end)

-- DRAGGING IMPLEMENTATION (robust across devices)
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    RainbowBorder.Position = MainFrame.Position - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local success, err = pcall(function() updateDrag(dragInput) end)
        if not success then
            -- ignore errors during drag
        end
    end
end)

-- Ensure initial visibility and sizes are consistent
for _,obj in ipairs(childrenToHide) do
    if obj and obj:IsA("GuiObject") then
        obj.Visible = true
    end
end

-- Simple stub addLog if your original function isn't present (preserve compatibility)
if not _G._AutoJointerAddLog then
    function addLog(text)
        print("[AutoJointer LOG] "..tostring(text))
    end
else
    -- if there's a global wrapper (unlikely), use it
    addLog = _G._AutoJointerAddLog
end

-- Ready
addLog("[UI] AutoJointer UI loaded (clipboard uses setclipboard if available).")

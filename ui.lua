--// UI Objects
local ScreenGui = script.Parent
local MainFrame = ScreenGui.MainFrame
local Header = MainFrame.Header
local CloseButton = Header.CloseButton
local DiscordButton = MainFrame.DiscordButton
local AutoJoinButton = MainFrame.AutoJoinButton
local DiscordLabel = MainFrame.DiscordLabel

--// Copy-to-Clipboard (Roblox-safe)
local DiscordTag = "discord.gg/YOURCODE"

DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DiscordTag)
    end
end)

--// Make Discord text more visible
DiscordLabel.Text = DiscordTag
DiscordLabel.TextScaled = true

--// Auto Join Toggle (Safe mock)
local autoJoinEnabled = false

AutoJoinButton.MouseButton1Click:Connect(function()
    autoJoinEnabled = not autoJoinEnabled
    
    if autoJoinEnabled then
        AutoJoinButton.Text = "Working..."
    else
        AutoJoinButton.Text = "Auto Join"
    end
end)

--// Collapse / Expand UI
local isCollapsed = false
local originalSize = MainFrame.Size

CloseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed

    if isCollapsed then
        MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Header then v.Visible = false end
        end
    else
        MainFrame.Size = originalSize
        for _, v in pairs(MainFrame:GetChildren()) do
            v.Visible = true
        end
    end
end)

--// UI Dragging (Header is draggable)
local UIS = game:GetService("UserInputService")
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

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)


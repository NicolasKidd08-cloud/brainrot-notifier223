--// SERVICES
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

--// MAIN UI OBJECTS
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 420) 
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

local UICorner = Instance.new("UICorner", MainFrame)

--// TOP BAR (DRAGGABLE)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "Brainrot Notifier"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

--// CLOSE BUTTON
local ToggleButton = Instance.new("TextButton", TopBar)
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 2)
ToggleButton.Text = "X"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
Instance.new("UICorner", ToggleButton)

--// DISCORD COPY BUTTON
local DiscordButton = Instance.new("TextButton", MainFrame)
DiscordButton.Size = UDim2.new(1, -20, 0, 40)
DiscordButton.Position = UDim2.new(0, 10, 0, 50)
DiscordButton.Text = "Click to Copy Discord: discord.gg/YOURSERVER"
DiscordButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DiscordButton.TextColor3 = Color3.fromRGB(0, 200, 255)
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.TextSize = 15
Instance.new("UICorner", DiscordButton)

--// AUTO-JOIN BUTTON
local AutoJoin = Instance.new("TextButton", MainFrame)
AutoJoin.Size = UDim2.new(1, -20, 0, 40)
AutoJoin.Position = UDim2.new(0, 10, 0, 100)
AutoJoin.Text = "Auto-Join"
AutoJoin.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AutoJoin.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoJoin.Font = Enum.Font.GothamBold
AutoJoin.TextSize = 15
Instance.new("UICorner", AutoJoin)

--// STATE VARIABLES
local isCollapsed = false
local fullSize = MainFrame.Size
local collapsedSize = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 45)

local autoJoinRunning = false

----------------------------------------------------
--// COPY DISCORD
----------------------------------------------------
DiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/YOURSERVER")
    DiscordButton.Text = "Copied!"
    task.wait(1)
    DiscordButton.Text = "Click to Copy Discord: discord.gg/YOURSERVER"
end)

----------------------------------------------------
--// AUTO-JOIN TOGGLE
----------------------------------------------------
AutoJoin.MouseButton1Click:Connect(function()
    autoJoinRunning = not autoJoinRunning

    if autoJoinRunning then
        AutoJoin.Text = "Working..."
        AutoJoin.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        AutoJoin.Text = "Auto-Join"
        AutoJoin.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

----------------------------------------------------
--// COLLAPSE / EXPAND
----------------------------------------------------
ToggleButton.MouseButton1Click:Connect(function()
    if isCollapsed then
        MainFrame:TweenSize(fullSize, "Out", "Quad", 0.25, true)
    else
        MainFrame:TweenSize(collapsedSize, "Out", "Quad", 0.25, true)
    end
    isCollapsed = not isCollapsed
end)

----------------------------------------------------
--// DRAGGING SYSTEM
----------------------------------------------------
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)


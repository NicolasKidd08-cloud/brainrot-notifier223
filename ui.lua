-- Nick & Scrap’s Auto Jointer – Small Version (500 x 320)
-- UI-only, safe. Drag + Open/Close toggle.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")


-- remove old gui
local old = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if old then old:Destroy() end


---------------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------------
local UI_W, UI_H = 500, 320          -- smaller size
local HEADER_H = 46

local FULL_SIZE = UDim2.new(0, UI_W, 0, UI_H)
local CLOSED_SIZE = UDim2.new(0, UI_W, 0, HEADER_H)


---------------------------------------------------------------------
-- ScreenGui
---------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NickScrapAutoJoiner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui


---------------------------------------------------------------------
-- Main Frame
---------------------------------------------------------------------
local Main = Instance.new("Frame")
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(28,29,33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- rainbow border
task.spawn(function()
    while true do
        for i = 0, 255 do
            stroke.Color = Color3.fromHSV(i/255, 0.85, 1)
            task.wait(0.02)
        end
    end
end)


---------------------------------------------------------------------
-- Header
---------------------------------------------------------------------
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,HEADER_H)
Header.BackgroundColor3 = Color3.fromRGB(22,22,24)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(145,255,150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "Nick & Scrap’s Auto Jointer"
Title.Parent = Header


---------------------------------------------------------------------
-- Toggle Button (^)
---------------------------------------------------------------------
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 40, 1, 0)
Toggle.Position = UDim2.new(1, -50, 0, 0)
Toggle.BackgroundTransparency = 1
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 22
Toggle.TextColor3 = Color3.fromRGB(255,60,60)
Toggle.Text = "^"
Toggle.Name = "ToggleButton"
Toggle.Parent = Header


---------------------------------------------------------------------
-- Contents Frame
---------------------------------------------------------------------
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1,0,1,-HEADER_H)
Body.Position = UDim2.new(0,0,0,HEADER_H)
Body.BackgroundColor3 = Color3.fromRGB(32,32,36)
Body.BorderSizePixel = 0
Body.Name = "Body"
Body.Parent = Main

Instance.new("UICorner", Body).CornerRadius = UDim.new(0,10)

-- Dummy text so you can see area
local BodyText = Instance.new("TextLabel")
BodyText.Size = UDim2.new(1,0,1,0)
BodyText.BackgroundTransparency = 1
BodyText.Font = Enum.Font.Gotham
BodyText.TextSize = 18
BodyText.TextColor3 = Color3.fromRGB(200,200,200)
BodyText.Text = "UI Content Here"
BodyText.Parent = Body



---------------------------------------------------------------------
-- Dragging
---------------------------------------------------------------------
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)


---------------------------------------------------------------------
-- Open / Close Toggle
---------------------------------------------------------------------
local isOpen = true

Toggle.MouseButton1Click:Connect(function()
    isOpen = not isOpen

    local newSize = isOpen and FULL_SIZE or CLOSED_SIZE
    local newText = isOpen and "^" or "v"

    Toggle.Text = newText
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        Size = newSize
    }):Play()
end)

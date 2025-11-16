--// CREATE SCREEN GUI
local Gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
Gui.ResetOnSpawn = false

--// MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 800, 0, 350)
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Main.BorderSizePixel = 0

-- Purple border like your screenshot
local Border = Instance.new("UIStroke", Main)
Border.Color = Color3.fromRGB(140, 0, 255)
Border.Thickness = 3

-- Round corners
local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 12)

--// HEADER BAR
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

--// TITLE TEXT
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0, 255, 0)

--// DISCORD TEXT (copies when clicked)
local CopyLabel = Instance.new("TextButton", Header)
CopyLabel.Size = UDim2.new(1, -60, 0, 18)
CopyLabel.Position = UDim2.new(0, 10, 0, 20)
CopyLabel.BackgroundTransparency = 1
CopyLabel.Text = "Discord: discord.gg/pAg5FBKj"
CopyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CopyLabel.Font = Enum.Font.Gotham
CopyLabel.TextSize = 14

--// COPY FUNCTION
CopyLabel.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/pAg5FBKj")
end)

--// CLOSE BUTTON (red one)
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -35, 0, 7)
Close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 16
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(1, 0)

--// CONTENT AREA
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1

--// TOGGLE COLLAPSE LOGIC
local collapsed = false
local fullSize = Main.Size

Close.MouseButton1Click:Connect(function()
    collapsed = not collapsed

    if collapsed then
        -- collapse to just header bar
        Main.Size = UDim2.new(0, 260, 0, 40)
        Content.Visible = false
    else
        -- reopen everything
        Main.Size = fullSize
        Content.Visible = true
    end
end)

--// CTRL TOGGLE ENTIRE UI
local UIS = game:GetService("UserInputService")
local uiVisible = true

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        Main.Visible = uiVisible
    end
end)

--// DRAGGABLE UI
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
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

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

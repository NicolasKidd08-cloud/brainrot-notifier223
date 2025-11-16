-- LEFT SIDEBAR
local Side = Instance.new("Frame")
Side.Name = "Side"
Side.Size = UDim2.new(0, 200, 1, 0)
Side.Position = UDim2.new(0, 0, 0, 0)
Side.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
Side.Parent = Content

local SideCorner = Instance.new("UICorner", Side)
SideCorner.CornerRadius = UDim.new(0, 12)

-- "Features" title
local FeaturesTitle = Instance.new("TextLabel")
FeaturesTitle.Name = "FeaturesTitle"
FeaturesTitle.Size = UDim2.new(1, 0, 0, 35)
FeaturesTitle.Position = UDim2.new(0, 0, 0, 10)
FeaturesTitle.BackgroundTransparency = 1
FeaturesTitle.Text = "Features"
FeaturesTitle.Font = Enum.Font.GothamBold
FeaturesTitle.TextScaled = true
FeaturesTitle.TextColor3 = Color3.fromRGB(255,255,255)
FeaturesTitle.Parent = Side

-- FIXED: Proper spacing container
local ButtonsHolder = Instance.new("Frame")
ButtonsHolder.Size = UDim2.new(1, 0, 1, -160)
ButtonsHolder.Position = UDim2.new(0, 0, 0, 55)
ButtonsHolder.BackgroundTransparency = 1
ButtonsHolder.Parent = Side

-- Helper to make buttons
local function MakeButton(parent, labelText, offsetY)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -30, 0, 48)
    B.Position = UDim2.new(0, 15, 0, offsetY)
    B.BackgroundColor3 = Color3.fromRGB(50, 55, 60)
    B.TextColor3 = Color3.fromRGB(255,255,255)
    B.Text = labelText
    B.Font = Enum.Font.GothamBold
    B.TextScaled = true
    B.Parent = parent
    local c = Instance.new("UICorner", B)
    c.CornerRadius = UDim.new(0, 8)
    return B
end

-- FIXED SPACING: AutoJoin
local AutoJoinBtn = MakeButton(ButtonsHolder, "Auto Join", 0)
local AutoJoinEnabled = false
AutoJoinBtn.MouseButton1Click:Connect(function()
    AutoJoinEnabled = not AutoJoinEnabled
    AutoJoinBtn.Text = AutoJoinEnabled and "Working..." or "Auto Join"
end)

-- FIXED SPACING: Persistent Rejoin (separated)
local PersistentBtn = MakeButton(ButtonsHolder, "Persistent Rejoin", 60)
local PersistentEnabled = false
PersistentBtn.MouseButton1Click:Connect(function()
    PersistentEnabled = not PersistentEnabled
    PersistentBtn.Text = PersistentEnabled and "Running..." or "Persistent Rejoin"
end)

-- FIXED SPACING: Minimum label
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(1, -30, 0, 24)
MinLabel.Position = UDim2.new(0, 15, 0, 125)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Minimum/sec (MS) (Millions)"
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextScaled = true
MinLabel.TextColor3 = Color3.fromRGB(200,200,200)
MinLabel.Parent = Side

-- FIXED SPACING: InputBox
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -30, 0, 42)
InputBox.Position = UDim2.new(0, 15, 0, 155)
InputBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
InputBox.Text = "10"
InputBox.Font = Enum.Font.GothamBold
InputBox.TextScaled = true
InputBox.TextColor3 = Color3.fromRGB(255,255,255)
InputBox.Parent = Side
local inputCorner = Instance.new("UICorner", InputBox)
inputCorner.CornerRadius = UDim.new(0, 8)

-- Status label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 20)
Status.Position = UDim2.new(0, 15, 1, -34)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.Font = Enum.Font.Gotham
Status.TextScaled = true
Status.TextColor3 = Color3.fromRGB(160,160,160)
Status.Parent = Side

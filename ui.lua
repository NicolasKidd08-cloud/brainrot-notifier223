-- Nicolas's AJ - Luarmor styled panel (UI ONLY)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NicolasAJ_UI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- HEADER
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Header.BorderSizePixel = 0

local HeaderText = Instance.new("TextLabel")
HeaderText.Parent = Header
HeaderText.Text = "Nicolas's AJ"
HeaderText.TextColor3 = Color3.fromRGB(255,255,255)
HeaderText.Font = Enum.Font.GothamBold
HeaderText.TextSize = 18
HeaderText.Position = UDim2.new(0, 15, 0, 0)
HeaderText.Size = UDim2.new(1, -20, 1, 0)
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 125, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(23,23,23)
Sidebar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 8)

local btnNames = {"Dashboard", "A", "A"}

for i, name in ipairs(btnNames) do
    local Btn = Instance.new("TextButton")
    Btn.Parent = Sidebar
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, (i-1)*45 + 10)
    Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Btn.Text = name
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 16
    Btn.TextColor3 = Color3.fromRGB(200,200,200)
    Btn.BorderSizePixel = 0

    local bc = Instance.new("UICorner", Btn)
    bc.CornerRadius = UDim.new(0, 6)
end

-- CONTENT AREA
local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Size = UDim2.new(1, -125, 1, -40)
Content.Position = UDim2.new(0, 125, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(20,20,20)
Content.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.CornerRadius = UDim.new(0, 8)

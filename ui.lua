-- Main UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 500) -- bigger UI
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 45) -- dark navy background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 15, 35) -- navy blue
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Brainrot Notifier"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- CLOSE BUTTON (NOW WORKS)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 1, 0)
Close.Position = UDim2.new(1, -40, 0, 0)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.BackgroundTransparency = 1
Close.Parent = TopBar

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- LEFT SIDE FEATURE LIST (SMALLER)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 24, 55)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local FeaturesTitle = Instance.new("TextLabel")
FeaturesTitle.Text = "Features"
FeaturesTitle.Font = Enum.Font.GothamBold
FeaturesTitle.TextSize = 20
FeaturesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FeaturesTitle.BackgroundTransparency = 1
FeaturesTitle.Position = UDim2.new(0, 10, 0, 10)
FeaturesTitle.Size = UDim2.new(1, -20, 0, 20)
FeaturesTitle.Parent = Sidebar

-- BRAINROT LIST PANEL (BIGGER)
local BrainrotPanel = Instance.new("Frame")
BrainrotPanel.Size = UDim2.new(1, -160, 1, -38)
BrainrotPanel.Position = UDim2.new(0, 160, 0, 38)
BrainrotPanel.BackgroundColor3 = Color3.fromRGB(30, 32, 70)
BrainrotPanel.BorderSizePixel = 0
BrainrotPanel.Parent = MainFrame

local BrainrotLabel = Instance.new("TextLabel")
BrainrotLabel.Text = "Brainrots"
BrainrotLabel.Font = Enum.Font.GothamBold
BrainrotLabel.TextSize = 22
BrainrotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrainrotLabel.Position = UDim2.new(0, 10, 0, 10)
BrainrotLabel.BackgroundTransparency = 1
BrainrotLabel.Size = UDim2.new(1, -20, 0, 25)
BrainrotLabel.Parent = BrainrotPanel

-- SEARCH BAR
local Search = Instance.new("TextBox")
Search.PlaceholderText = "Search brainrot…"
Search.Font = Enum.Font.Gotham
Search.TextSize = 18
Search.TextColor3 = Color3.fromRGB(255, 255, 255)
Search.BackgroundColor3 = Color3.fromRGB(40, 42, 90)
Search.BorderSizePixel = 0
Search.Position = UDim2.new(0, 10, 0, 45)
Search.Size = UDim2.new(1, -20, 0, 32)
Search.Parent = BrainrotPanel

-- SCROLLING LIST
local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 1, -90)
List.Position = UDim2.new(0, 10, 0, 85)
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.ScrollBarThickness = 6
List.BackgroundTransparency = 1
List.Parent = BrainrotPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = List

-- FUTURE: FILL LIST WITH YOUR SECRET + OG brainrots
-- (I can generate this automatically if you give me the list)

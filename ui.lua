--// Brainrot UI (SAFE + WORKING VERSION FOR ALL PLAYERS)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 420, 0, 480)
main.Position = UDim2.new(0.5, -210, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
main.Active = true
main.Draggable = true

-- Top bar
local top = Instance.new("Frame")
top.Parent = main
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(10, 10, 70)

local title = Instance.new("TextLabel")
title.Parent = top
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Brainrot Notifier"

-- Close button
local close = Instance.new("TextButton")
close.Parent = top
close.Size = UDim2.new(0, 40, 1, 0)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
close.TextColor3 = Color3.new(1,1,1)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Content container
local content = Instance.new("Frame")
content.Parent = main
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1

local ui = Instance.new("UIListLayout", content)
ui.Padding = UDim.new(0, 8)

-- Auto-Join toggle
local toggle = Instance.new("TextButton")
toggle.Parent = content
toggle.Size = UDim2.new(1, 0, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 18
toggle.Text = "Auto Join: OFF"

local autoJoin = false

toggle.MouseButton1Click:Connect(function()
	autoJoin = not autoJoin
	toggle.Text = autoJoin and "Auto Join: ON" or "Auto Join: OFF"
	toggle.BackgroundColor3 = autoJoin and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(40, 40, 60)
end)

-- Minimum rarity box
local minBox = Instance.new("TextBox")
minBox.Parent = content
minBox.Size = UDim2.new(1, 0, 0, 40)
minBox.PlaceholderText = "Minimum rarity"
minBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
minBox.TextColor3 = Color3.new(1,1,1)
minBox.Font = Enum.Font.Gotham
minBox.TextSize = 18

-- Ignore list box
local ignoreBox = Instance.new("TextBox")
ignoreBox.Parent = content
ignoreBox.Size = UDim2.new(1, 0, 0, 40)
ignoreBox.PlaceholderText = "Ignore list: comma separated"
ignoreBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
ignoreBox.TextColor3 = Color3.new(1,1,1)
ignoreBox.Font = Enum.Font.Gotham
ignoreBox.TextSize = 18

-- Log display
local log = Instance.new("TextLabel")
log.Parent = content
log.Size = UDim2.new(1, 0, 1, -140)
log.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
log.TextColor3 = Color3.new(1,1,1)
log.TextWrapped = true
log.Font = Enum.Font.Gotham
log.TextSize = 16
log.TextYAlignment = Enum.TextYAlignment.Top
log.Text = "Brainrot logs:\n"

-- Demo event to test
task.spawn(function()
	while task.wait(3) do
		local name = "RandomBrainrot_" .. math.random(1,99)
		local rarity = math.random(1,50)

		log.Text = log.Text .. "\n• " .. name .. " (Rarity: " .. rarity .. ")"
	end
end)


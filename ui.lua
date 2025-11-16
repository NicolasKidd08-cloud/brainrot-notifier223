-- Nick & Scrap's Auto Jointer UI (with working minimize button)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJointerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Title Label
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Nick & Scrap's Auto Jointer - Discord/PGT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- ^ Toggle Button (your real button)
local Toggle = Instance.new("TextButton")
Toggle.Name = "^"
Toggle.Text = "^"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
Toggle.Size = UDim2.new(0, 40, 1, 0)
Toggle.Position = UDim2.new(1, -40, 0, 0)
Toggle.Parent = TopBar

-- Body Frame (everything that hides on minimize)
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 1, -40)
Body.Position = UDim2.new(0, 0, 0, 40)
Body.BackgroundTransparency = 1
Body.Parent = MainFrame

-- Discord Button
local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Text = "Copy Discord: https://discord.gg/123abc"
DiscordButton.Font = Enum.Font.GothamSemibold
DiscordButton.TextSize = 15
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DiscordButton.Size = UDim2.new(0, 300, 0, 30)
DiscordButton.Position = UDim2.new(0, 60, 0, 20)
DiscordButton.Parent = Body

DiscordButton.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/123abc")
end)

-- Minimize Logic
local Minimized = false
local FullHeight = 320
local MinimizedHeight = 40

Toggle.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		-- collapse
		Body.Visible = false
		MainFrame:TweenSize(
			UDim2.new(0, 420, 0, MinimizedHeight),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)
		Toggle.Text = "v"
	else
		-- expand
		MainFrame:TweenSize(
			UDim2.new(0, 420, 0, FullHeight),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)
		task.wait(0.22)
		Body.Visible = true
		Toggle.Text = "^"
	end
end)

--// SAFE MOVABLE + COLLAPSIBLE UI
--// No exploits, no HTTP, no auto-joiners, nothing harmful.
--// Works in Roblox Studio & live game.

local Gui = Instance.new("ScreenGui")
Gui.Name = "CustomUI"
Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Gui.ResetOnSpawn = false

--// MAIN FRAME
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 160)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = Gui

--// TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Brainrot UI"
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

--// COLLAPSE BUTTON
local Collapse = Instance.new("TextButton")
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 5)
Collapse.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Collapse.Text = "-"
Collapse.TextColor3 = Color3.fromRGB(255, 255, 255)
Collapse.Font = Enum.Font.GothamBold
Collapse.TextSize = 20
Collapse.Parent = Frame

--// DISCORD COPY BUTTON
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(1, -20, 0, 40)
CopyBtn.Position = UDim2.new(0, 10, 0, 50)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 18
CopyBtn.Font = Enum.Font.Gotham
CopyBtn.Text = "Copy Invite: discord.gg/example"
CopyBtn.Parent = Frame

--// EXTRA CONTENT (hidden when collapsed)
local ExtraBox = Instance.new("TextLabel")
ExtraBox.Size = UDim2.new(1, -20, 0, 40)
ExtraBox.Position = UDim2.new(0, 10, 0, 100)
ExtraBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ExtraBox.Text = "Extra UI Stuff Here"
ExtraBox.TextSize = 16
ExtraBox.TextColor3 = Color3.fromRGB(200, 200, 200)
ExtraBox.Font = Enum.Font.Gotham
ExtraBox.Parent = Frame

--// COLLAPSE LOGIC
local collapsed = false
local fullHeight = 160
local collapsedHeight = 45

Collapse.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	
	if collapsed then
		-- shrink UI → hide extra content
		Frame.Size = UDim2.new(0, 280, 0, collapsedHeight)
		Collapse.Text = "+"
		CopyBtn.Position = UDim2.new(0, 10, 0, 5)
		Title.Visible = false
		ExtraBox.Visible = false
	else
		-- reopen UI
		Frame.Size = UDim2.new(0, 280, 0, fullHeight)
		Collapse.Text = "-"
		CopyBtn.Position = UDim2.new(0, 10, 0, 50)
		Title.Visible = true
		ExtraBox.Visible = true
	end
end)

--// COPY TO CLIPBOARD
CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/example")
	end
	
	CopyBtn.Text = "Copied!"
	task.wait(0.7)
	CopyBtn.Text = "Copy Invite: discord.gg/example"
end)


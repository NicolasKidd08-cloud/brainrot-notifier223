--// MAIN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

--// MAIN FRAME
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

--// TITLE BAR
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Brainrot UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

--// RED COLLAPSE BUTTON
local Collapse = Instance.new("TextButton")
Collapse.Parent = Frame
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 0)
Collapse.Text = "X"
Collapse.Font = Enum.Font.GothamBold
Collapse.TextSize = 16
Collapse.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Collapse.TextColor3 = Color3.fromRGB(255, 255, 255)

--// DISCORD BUTTON
local Discord = Instance.new("TextButton")
Discord.Parent = Frame
Discord.Size = UDim2.new(0, 260, 0, 40)
Discord.Position = UDim2.new(0, 20, 0, 50)
Discord.Text = "Copy Discord Link"
Discord.Font = Enum.Font.GothamBold
Discord.TextSize = 16
Discord.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Discord.TextColor3 = Color3.fromRGB(255, 255, 255)

--// COPY TO CLIPBOARD (Roblox Studio ONLY)
Discord.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/yourlinkhere")
	end
end)

---------------------------------------------------
--// COLLAPSE / EXPAND SYSTEM
---------------------------------------------------

local collapsed = false
local fullSize = Frame.Size
local fullTitleSize = Title.Size

Collapse.MouseButton1Click:Connect(function()
	if not collapsed then
		-- collapse
		collapsed = true
		Frame.Size = UDim2.new(0, 300, 0, 35)
		Title.Size = UDim2.new(1, -40, 0, 30)
		for _,v in ipairs(Frame:GetChildren()) do
			if v ~= Title and v ~= Collapse then
				v.Visible = false
			end
		end
	else
		-- expand
		collapsed = false
		Frame.Size = fullSize
		Title.Size = fullTitleSize
		for _,v in ipairs(Frame:GetChildren()) do
			v.Visible = true
		end
	end
end)


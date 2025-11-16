--// Clean Neon UI with Copy-to-Clipboard + Toggle + Draggable

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NeonBrainrotUI"
gui.ResetOnSpawn = false

----------------------------------------------------
-- MAIN FRAME
----------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Brainrot UI"
title.TextColor3 = Color3.fromRGB(0, 255, 0) -- NEON GREEN
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24

----------------------------------------------------
-- COPY LINK BUTTON
----------------------------------------------------
local linkButton = Instance.new("TextButton", frame)
linkButton.Size = UDim2.new(1, -20, 0, 40)
linkButton.Position = UDim2.new(0, 10, 0, 50)
linkButton.Text = "Copy Discord Link"
linkButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
linkButton.TextColor3 = Color3.fromRGB(0, 0, 0)
linkButton.Font = Enum.Font.GothamBold
linkButton.TextSize = 20

Instance.new("UICorner", linkButton).CornerRadius = UDim.new(0, 10)

local DISCORD_LINK = "https://discord.gg/YOURSERVERHERE"

linkButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
	end
	StarterGui:SetCore("SendNotification", {
		Title = "Copied";
		Text = "Discord link copied!";
		Duration = 2;
	})
end)

----------------------------------------------------
-- TOGGLE BUTTON (small circle button)
----------------------------------------------------
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 60, 0, 60)
toggle.Position = UDim2.new(0.1, 0, 0.1, 0)
toggle.Text = "UI"
toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 22

Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

----------------------------------------------------
-- TOGGLE LOGIC
----------------------------------------------------
local open = true

toggle.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
end)

----------------------------------------------------
-- DRAGGING (FRAME + TOGGLE)
----------------------------------------------------
local function makeDraggable(object)
	local dragging = false
	local dragStart
	local startPos

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
		end
	end)

	object.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(frame)
makeDraggable(toggle)

--========================--
--  UI REFERENCES
--========================--

local MainFrame = script.Parent.MainFrame
local Header = MainFrame.Header
local CollapseBtn = Header.CollapseBtn
local RainbowBorder = MainFrame.RainbowBorder

local BORDER_THICKNESS = 3
local HeaderHeight = 40

local MaxHeight = UDim2.new(0, 400, 0, 350) -- your original UI size
local MinHeight = UDim2.new(0, 400, 0, HeaderHeight) -- collapsed height

local isExpanded = true

--========================--
--  MAKE UI DRAGGABLE
--========================--

local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

Header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		RainbowBorder.Position = MainFrame.Position - UDim2.new(0, BORDER_THICKNESS, 0, BORDER_THICKNESS)
	end
end)

--========================--
--  COLLAPSE / EXPAND
--========================--

CollapseBtn.MouseButton1Click:Connect(function()

	if isExpanded then
		-- COLLAPSE
		for _, v in ipairs(MainFrame:GetChildren()) do
			if v ~= Header and v ~= RainbowBorder then
				v.Visible = false
			end
		end

		MainFrame:TweenSize(
			MinHeight,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)

		RainbowBorder:TweenSize(
			MinHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)

		isExpanded = false

	else
		-- EXPAND
		for _, v in ipairs(MainFrame:GetChildren()) do
			v.Visible = true
		end

		MainFrame:TweenSize(
			MaxHeight,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)

		RainbowBorder:TweenSize(
			MaxHeight + UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25
		)

		isExpanded = true
	end
end)

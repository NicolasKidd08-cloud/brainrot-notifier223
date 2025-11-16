--// Lumora Priority Style UI (Dark Neon Theme)
--// Safe in-game UI only — NO exploit behavior

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UI = {}

--// Create Function
function UI:Create()

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "LumoraPriorityUI"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    -- Main Frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 750, 0, 400)
    main.Position = UDim2.new(0.5, -375, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    main.BorderSizePixel = 0
    main.Parent = gui

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    -- Title Bar
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    title.BorderSizePixel = 0
    title.Parent = main

    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 26
    titleText.Text = "Lumora Priority"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = title

    -- Close Button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 40, 0, 40)
    close.Position = UDim2.new(1, -45, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Parent = title

    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 10)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    ----------------------------------------------------
    -- LEFT PANEL -- (Settings Column)
    ----------------------------------------------------

    local left = Instance.new("Frame")
    left.Size = UDim2.new(0, 230, 1, -50)
    left.Position = UDim2.new(0, 0, 0, 50)
    left.BackgroundTransparency = 1
    left.Parent = main

    local function CreateToggle(text, yOffset)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 32)
        container.Position = UDim2.new(0, 10, 0, yOffset)
        container.BackgroundTransparency = 1
        container.Parent = left

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = text
        label.Parent = container

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 40, 0, 25)
        toggle.Position = UDim2.new(0.8, 0, 0, 3)
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggle.Text = ""
        toggle.Parent = container

        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
        end)

        return toggle, function() return state end
    end

    -- Toggles like screenshot
    CreateToggle("Auto Join", 10)
    CreateToggle("Pet Name Filters", 50)

    -- Money Filter
    local lbl = Instance.new("TextLabel")
    lbl.Text = "Money Filter"
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, 100)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = left

    local moneyBox = Instance.new("TextBox")
    moneyBox.Size = UDim2.new(0.8, 0, 0, 30)
    moneyBox.Position = UDim2.new(0, 10, 0, 135)
    moneyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    moneyBox.BorderSizePixel = 0
    moneyBox.Font = Enum.Font.Gotham
    moneyBox.TextSize = 18
    moneyBox.TextColor3 = Color3.new(1, 1, 1)
    moneyBox.Text = "100"
    moneyBox.Parent = left

    Instance.new("UICorner", moneyBox).CornerRadius = UDim.new(0, 6)

    ----------------------------------------------------
    -- RIGHT PANEL (List)
    ----------------------------------------------------

    local right = Instance.new("Frame")
    right.Size = UDim2.new(1, -240, 1, -50)
    right.Position = UDim2.new(0, 240, 0, 50)
    right.BackgroundTransparency = 1
    right.Parent = main

    -- Headers
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.Parent = right

    local petHeader = Instance.new("TextLabel")
    petHeader.Size = UDim2.new(0.6, 0, 1, 0)
    petHeader.BackgroundTransparency = 1
    petHeader.Font = Enum.Font.GothamBold
    petHeader.TextSize = 20
    petHeader.TextColor3 = Color3.new(1, 1, 1)
    petHeader.TextXAlignment = Enum.TextXAlignment.Left
    petHeader.Text = "Pet Name"
    petHeader.Parent = header

    local moneyHeader = Instance.new("TextLabel")
    moneyHeader.Size = UDim2.new(0.4, 0, 1, 0)
    moneyHeader.Position = UDim2.new(0.6, 0, 0, 0)
    moneyHeader.BackgroundTransparency = 1
    moneyHeader.Font = Enum.Font.GothamBold
    moneyHeader.TextSize = 20
    moneyHeader.TextColor3 = Color3.fromRGB(0, 255, 0)
    moneyHeader.TextXAlignment = Enum.TextXAlignment.Right
    moneyHeader.Text = "Money/Second"
    moneyHeader.Parent = header

    -- Scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -35)
    scroll.Position = UDim2.new(0, 0, 0, 35)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 5
    scroll.BackgroundTransparency = 1
    scroll.Parent = right

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll

    -- Function for adding items
    function UI:AddPet(name, moneyPerSec)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -10, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        item.BorderSizePixel = 0
        item.Parent = scroll

        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

        local nameText = Instance.new("TextLabel")
        nameText.Size = UDim2.new(0.6, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.Font = Enum.Font.Gotham
        nameText.TextSize = 18
        nameText.TextColor3 = Color3.new(1, 1, 1)
        nameText.TextXAlignment = Enum.TextXAlignment.Left
        nameText.Text = name
        nameText.Parent = item

        local moneyText = Instance.new("TextLabel")
        moneyText.Size = UDim2.new(0.4, 0, 1, 0)
        moneyText.Position = UDim2.new(0.6, 0, 0, 0)
        moneyText.BackgroundTransparency = 1
        moneyText.Font = Enum.Font.GothamBold
        moneyText.TextSize = 18
        moneyText.TextColor3 = Color3.fromRGB(0, 255, 0)
        moneyText.TextXAlignment = Enum.TextXAlignment.Right
        moneyText.Text = tostring(moneyPerSec) .. "/s"
        moneyText.Parent = item
    end

    return UI
end

-- Auto-create when loaded
return UI:Create()


--// UI LIBRARY SETUP
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local AutoJoinButton = Instance.new("TextButton")
local SettingsButton = Instance.new("TextButton")
local SettingsFrame = Instance.new("Frame")
local MinMoneyBox = Instance.new("TextBox")
local MaxMoneyBox = Instance.new("TextBox")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

-- Main Frame
Main.Size = UDim2.new(0, 300, 0, 120)
Main.Position = UDim2.new(0.03, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderSizePixel = 0

Title.Parent = Main
Title.Text = "Brainrot Notifier"
Title.Size = UDim2.new(1,0,0,25)
Title.BackgroundColor3 = Color3.fromRGB(20,20,20)
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 18

AutoJoinButton.Parent = Main
AutoJoinButton.Position = UDim2.new(0,10,0,40)
AutoJoinButton.Size = UDim2.new(0,130,0,35)
AutoJoinButton.Text = "Auto Join: OFF"
AutoJoinButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
AutoJoinButton.TextColor3 = Color3.new(1,1,1)
AutoJoinButton.TextSize = 14

SettingsButton.Parent = Main
SettingsButton.Position = UDim2.new(0,160,0,40)
SettingsButton.Size = UDim2.new(0,130,0,35)
SettingsButton.Text = "Settings"
SettingsButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
SettingsButton.TextColor3 = Color3.new(1,1,1)
SettingsButton.TextSize = 14

-- Settings Frame
SettingsFrame.Parent = Main
SettingsFrame.Position = UDim2.new(0,0,1,5)
SettingsFrame.Size = UDim2.new(1,0,0,110)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
SettingsFrame.Visible = false

MinMoneyBox.Parent = SettingsFrame
MinMoneyBox.PlaceholderText = "Min Money Per Sec"
MinMoneyBox.Size = UDim2.new(1,-20,0,35)
MinMoneyBox.Position = UDim2.new(0,10,0,10)
MinMoneyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinMoneyBox.TextColor3 = Color3.new(1,1,1)

MaxMoneyBox.Parent = SettingsFrame
MaxMoneyBox.PlaceholderText = "Max Money Per Sec"
MaxMoneyBox.Size = UDim2.new(1,-20,0,35)
MaxMoneyBox.Position = UDim2.new(0,10,0,55)
MaxMoneyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
MaxMoneyBox.TextColor3 = Color3.new(1,1,1)

-- LOGIC
local autoJoinEnabled = false

AutoJoinButton.MouseButton1Click:Connect(function()
    autoJoinEnabled = not autoJoinEnabled
    AutoJoinButton.Text = autoJoinEnabled and "Auto Join: ON" or "Auto Join: OFF"
end)

SettingsButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
end)

-- Auto Join Check Loop
task.spawn(function()
    while true do
        task.wait(1)

        if autoJoinEnabled then
            print("Checking brainrots...")  -- Replace with your join logic

            -- Example of reading min/max values
            local min = tonumber(MinMoneyBox.Text) or 0
            local max = tonumber(MaxMoneyBox.Text) or 999999

            -- your real logic would go here
        end
    end
end)

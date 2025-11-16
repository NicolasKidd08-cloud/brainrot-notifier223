--// Developer Debug Menu for Brainrot Spawns (SAFE VERSION)
--// This does NOT connect to exploits or Discord scraping.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotEvent = ReplicatedStorage:WaitForChild("BrainrotLog") -- RemoteEvent
local Allowed = { ["Nicolas Kidd"] = true } -- dev-only access

--// DEV-ONLY CHECK
if not Allowed[Players.LocalPlayer.Name] then
    return
end

--// UI CREATION
local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
ScreenGui.Name = "BrainrotDevMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 330)
Frame.Position = UDim2.new(0, 30, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 6)

-- Toggle
local Toggle = Instance.new("TextButton", Frame)
Toggle.Text = "Auto-Join: OFF"
Toggle.Size = UDim2.new(1, -10, 0, 40)
Toggle.Position = UDim2.new(0, 5, 0, 5)
Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local AutoJoinEnabled = false

Toggle.MouseButton1Click:Connect(function()
    AutoJoinEnabled = not AutoJoinEnabled
    Toggle.Text = AutoJoinEnabled and "Auto-Join: ON" or "Auto-Join: OFF"
end)

-- Min rarity box
local MinBox = Instance.new("TextBox", Frame)
MinBox.PlaceholderText = "Minimum rarity (number)"
MinBox.Size = UDim2.new(1, -10, 0, 40)
MinBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Ignore list
local IgnoreBox = Instance.new("TextBox", Frame)
IgnoreBox.PlaceholderText = "Ignore list (comma-separated)"
IgnoreBox.Size = UDim2.new(1, -10, 0, 40)
IgnoreBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Brainrot log
local LogLabel = Instance.new("TextLabel", Frame)
LogLabel.Size = UDim2.new(1, -10, 0, 180)
LogLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogLabel.TextWrapped = true
LogLabel.Text = "Logged brainrots:\n"

--// Receive server logs
BrainrotEvent.OnClientEvent:Connect(function(data)
    local name = data.name
    local rarity = data.rarity

    LogLabel.Text = LogLabel.Text .. ("\n• %s (rarity: %s)"):format(name, rarity)

    local minRare = tonumber(MinBox.Text)
    local ignoreList = {}

    for item in string.gmatch(IgnoreBox.Text, "([^,]+)") do
        ignoreList[item:lower()] = true
    end

    if AutoJoinEnabled and minRare and rarity >= minRare then
        if not ignoreList[name:lower()] then
            -- DEV-ONLY: Teleport
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId,
                data.server,
                Players.LocalPlayer
            )
        end
    end
end)


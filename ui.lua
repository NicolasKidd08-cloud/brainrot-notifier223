--// UI Elements
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:WaitForChild("YourGuiNameHere")

local MainFrame = ScreenGui.MainFrame
local AutoJoinButton = MainFrame.AutoJoinButton
local DiscordButton = MainFrame.DiscordButton
local ToggleButton = ScreenGui.ToggleButton
local DiscordLabel = MainFrame.DiscordLabel

--// Settings
local AUTOJOIN_ENABLED = false
local DISCORD_LINK = "https://discord.gg/YOURSERVER"

-- Make Discord text bigger
DiscordLabel.TextScaled = true
DiscordLabel.Text = DISCORD_LINK

--// Toggle UI Open/Close
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--// Auto-Join toggle logic
AutoJoinButton.MouseButton1Click:Connect(function()
    AUTOJOIN_ENABLED = not AUTOJOIN_ENABLED
    
    if AUTOJOIN_ENABLED then
        AutoJoinButton.Text = "Working..."
    else
        AutoJoinButton.Text = "Auto Join"
    end
end)

--// Copy Discord Link
DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
    elseif ClipboardService then
        ClipboardService:SetClipboard(DISCORD_LINK)
    end
    DiscordButton.Text = "Copied!"
    task.delay(1.5, function()
        DiscordButton.Text = "Copy Discord"
    end)
end)


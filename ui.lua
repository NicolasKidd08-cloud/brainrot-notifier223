"""
exasmole.py

This file contains the latest Roblox Lua snippets you asked for.
It writes two Lua files when executed locally (for easy copy/paste into Studio):

- JoinLoggerServer.lua  -> ServerScript (ServerScriptService)
- AutoJointerClientPatch.lua -> Client-side LocalScript patch snippet

Run this Python file if you want to dump the Lua files to disk for copy/paste.
"""

server_lua = '''-- JoinLoggerServer (ServerScriptService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ensure RemoteEvent exists
local joinEvent = ReplicatedStorage:FindFirstChild("JoinLogEvent")
if not joinEvent then
    joinEvent = Instance.new("RemoteEvent")
    joinEvent.Name = "JoinLogEvent"
    joinEvent.Parent = ReplicatedStorage
end

local function fireJoinPayload(payload)
    -- payload is a table with: type, message, playerName, userId, rarest = {name, value}, ms
    joinEvent:FireAllClients(payload)
end

Players.PlayerAdded:Connect(function(player)
    local playersCount = #Players:GetPlayers()
    local msg = string.format("[JOIN] %s (%d) joined. (%d players)", player.Name, player.UserId, playersCount)

    -- Example placeholders (replace with your real logic/source)
    local ms_value = 10000000 -- 10M example
    local rarest = { name = "Mega-Brainrot Gem", value = 5000000 }

    local payload = {
        type = "player_join",
        message = msg,
        playerName = player.Name,
        userId = player.UserId,
        rarest = rarest,
        ms = ms_value
    }

    fireJoinPayload(payload)
end)

Players.PlayerRemoving:Connect(function(player)
    local playersCount = #Players:GetPlayers() - 1
    local msg = string.format("[LEAVE] %s (%d) left. (%d players remaining)", player.Name, player.UserId, playersCount)
    local payload = {
        type = "player_leave",
        message = msg,
        playerName = player.Name,
        userId = player.UserId,
        rarest = { name = "N/A", value = 0 },
        ms = 0
    }
    fireJoinPayload(payload)
end)

-- Optional: expose a function for your other server code to call when an external
-- log arrives. Example usage from other server code:
-- fireJoinPayload({ type = "external_log", message = "...", rarest = {name=.., value=..}, ms = 11000000 })
'''

client_lua = '''-- AutoJointer Client Patch (insert into your AutoJointer LocalScript)
-- 1) Insert the ServerInfo UI block under the Right panel (after `LogTitle`)
-- 2) Adjust `LogScroll` position/size to make room
-- 3) Add the `joinEvent` listener (shown below) near your `addLog` function

-- Server Info panel (insert under the Right panel, after LogTitle)
local ServerInfo = Instance.new("Frame")
ServerInfo.Name = "ServerInfo"
ServerInfo.Size = UDim2.new(1, -30, 0, 62)
ServerInfo.Position = UDim2.new(0, 15, 0, 40)
ServerInfo.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
ServerInfo.BorderSizePixel = 0
ServerInfo.Parent = Right
ServerInfo.ZIndex = 3
Instance.new("UICorner", ServerInfo).CornerRadius = UDim.new(0, 8)

local RarestLabel = Instance.new("TextLabel")
RarestLabel.Name = "RarestLabel"
RarestLabel.Size = UDim2.new(1, -20, 0, 28)
RarestLabel.Position = UDim2.new(0, 10, 0, 6)
RarestLabel.BackgroundTransparency = 1
RarestLabel.Font = Enum.Font.Gotham
RarestLabel.TextSize = 14
RarestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RarestLabel.TextXAlignment = Enum.TextXAlignment.Left
RarestLabel.Text = "Rarest Brainrot: N/A"
RarestLabel.Parent = ServerInfo
RarestLabel.ZIndex = 4

local MSLabel = Instance.new("TextLabel")
MSLabel.Name = "MSLabel"
MSLabel.Size = UDim2.new(1, -20, 0, 20)
MSLabel.Position = UDim2.new(0, 10, 0, 34)
MSLabel.BackgroundTransparency = 1
MSLabel.Font = Enum.Font.Gotham
MSLabel.TextSize = 13
MSLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
MSLabel.TextXAlignment = Enum.TextXAlignment.Left
MSLabel.Text = "Money/sec (MS): N/A"
MSLabel.Parent = ServerInfo
MSLabel.ZIndex = 4

-- Make room: shift LogScroll down (adjust values in your script to match your layout)
LogScroll.Position = UDim2.new(0, 15, 0, 105) -- was 45
LogScroll.Size = UDim2.new(1, -30, 1, -140)    -- adjusted height

-- Listener: place this near your addLog function (client-side)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local joinEvent = ReplicatedStorage:WaitForChild("JoinLogEvent")

-- Helper to read MinMSBox (user input in Millions) and return raw value
local function getMinRequired()
    local rawInput = tonumber(MinMSBox.Text)
    if not rawInput then
        return 0
    end
    return rawInput * 1000000
end

joinEvent.OnClientEvent:Connect(function(payload)
    if type(payload) == "table" then
        local ms = tonumber(payload.ms) or 0
        local minRequired = getMinRequired()

        -- Only show events that meet or exceed the player's minimum
        if ms >= minRequired then
            -- Update Rarest label
            if payload.rarest and payload.rarest.name then
                local rareName = tostring(payload.rarest.name)
                if payload.rarest.value and tonumber(payload.rarest.value) and tonumber(payload.rarest.value) > 0 then
                    local v = tonumber(payload.rarest.value)
                    RarestLabel.Text = string.format("Rarest Brainrot: %s ($%s)", rareName, string.format("%,d", v))
                else
                    RarestLabel.Text = "Rarest Brainrot: " .. rareName
                end
            end

            -- Update MS label in friendly format
            local msText
            if ms >= 1000000 then
                msText = string.format("%.1fM", ms / 1000000)
            else
                msText = tostring(ms)
            end
            MSLabel.Text = "Money/sec (MS): " .. msText

            -- Add to log
            if payload.message then
                addLog(payload.message .. "  [MS: " .. msText .. "]")
            else
                addLog("[LOG] Event received. MS: " .. msText)
            end
        else
            -- filtered out: below player's min; do nothing (or optionally log to a filtered list)
        end
    elseif type(payload) == "string" then
        addLog(payload)
    end
end)
'''

def write_files():
    """Write the Lua snippets to disk for easy copy/paste into Roblox Studio."""
    import os
    base = os.path.dirname(__file__)
    server_path = os.path.join(base, "JoinLoggerServer.lua")
    client_path = os.path.join(base, "AutoJointerClientPatch.lua")

    with open(server_path, "w", encoding="utf-8") as f:
        f.write(server_lua)

    with open(client_path, "w", encoding="utf-8") as f:
        f.write(client_lua)

    print("Wrote:")
    print(" - ", server_path)
    print(" - ", client_path)

if __name__ == '__main__':
    write_files()

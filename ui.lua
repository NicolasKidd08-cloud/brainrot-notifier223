-- ServerScriptService/RareBrainrotNotifier.lua
-- Publishes when a rare player joins, subscribes to cross-server alerts,
-- and handles teleport requests from clients.

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- CONFIG
local CHANNEL = "RARE_BRAINROT_ALERT_V1" -- MessagingService channel (unique string)
local RARE_THRESHOLD = 5                 -- rarity value >= this is "rare"
local TELEPORT_COOLDOWN = 6              -- seconds per player cooldown for teleport requests

-- Ensure RemoteEvents exist
local function getOrCreateRemote(name, class)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if obj and obj:IsA(class) then return obj end
    obj = Instance.new(class)
    obj.Name = name
    obj.Parent = ReplicatedStorage
    return obj
end

local RemoteAlert = getOrCreateRemote("RareAlertEvent", "RemoteEvent")        -- server -> clients
local RemoteRequestTeleport = getOrCreateRemote("RequestTeleportEvent", "RemoteEvent") -- client -> server

-- simple in-memory cooldown tracker for teleports per player
local lastTeleportRequest = {}

-- Publish when a rare player joins THIS server
Players.PlayerAdded:Connect(function(player)
    -- Wait a bit for potential BrainrotRarity value (your game's system must set it on the Player object)
    task.spawn(function()
        task.wait(0.8) -- small delay to allow scripts to set player values
        local rarityValue = player:FindFirstChild("BrainrotRarity")
        if rarityValue and type(rarityValue.Value) == "number" and rarityValue.Value >= RARE_THRESHOLD then
            local payload = {
                name = player.Name,
                userId = player.UserId,
                rarity = rarityValue.Value,
                placeId = game.PlaceId,
                jobId = tostring(game.JobId), -- jobId identifies this server instance
                timestamp = os.time(),
            }
            -- Publish cross-server message
            local ok, err = pcall(function()
                MessagingService:PublishAsync(CHANNEL, payload)
            end)
            if not ok then
                warn("Failed to publish rare alert:", err)
            else
                print(("Published rare alert for %s (rarity=%s) from job %s"):format(player.Name, tostring(rarityValue.Value), payload.jobId))
            end
        end
    end)
end)

-- Subscribe to incoming rare alerts from other servers (and our own too)
local function onMessage(received)
    -- received.Data should be the payload
    local payload = received and received.Data
    if type(payload) ~= "table" then return end

    -- If the alert came from THIS server, it's still fine to forward locally (helps local players)
    -- Forward to all players or to admins only — we'll send to players and client will filter by admin list if needed
    RemoteAlert:FireAllClients(payload)
    print(("Received rare alert: %s (rarity=%s) from job %s"):format(tostring(payload.name), tostring(payload.rarity), tostring(payload.jobId)))
end

local ok, err = pcall(function()
    -- SubscribeAsync returns a subscription object on success
    MessagingService:SubscribeAsync(CHANNEL, onMessage)
end)
if not ok then
    warn("Failed to subscribe to MessagingService channel:", err)
end

-- Handle teleport requests from clients
RemoteRequestTeleport.OnServerEvent:Connect(function(player, request)
    -- request should be a table { jobId = "...", placeId = <number>, requestedFor = player.UserId (optional) }
    if type(request) ~= "table" or type(request.jobId) ~= "string" then
        RemoteAlert:FireClient(player, { error = "Invalid teleport request." })
        return
    end

    -- Basic cooldown: prevent spamming teleport calls
    local last = lastTeleportRequest[player.UserId]
    if last and tick() - last < TELEPORT_COOLDOWN then
        RemoteAlert:FireClient(player, { error = ("Please wait %.1f seconds before teleporting again."):format(TELEPORT_COOLDOWN - (tick()-last)) })
        return
    end
    lastTeleportRequest[player.UserId] = tick()

    local targetJobId = request.jobId
    local targetPlaceId = request.placeId or game.PlaceId

    -- Don't teleport to the server you're already in
    if tostring(game.JobId) == tostring(targetJobId) then
        RemoteAlert:FireClient(player, { error = "You are already in that server." })
        return
    end

    -- Attempt to teleport this player to the target server instance
    task.spawn(function()
        local success, err = pcall(function()
            -- TeleportToPlaceInstance teleports the given players to a specific server instance
            TeleportService:TeleportToPlaceInstance(targetPlaceId, targetJobId, { player })
        end)
        if not success then
            warn("Teleport error for player", player.Name, err)
            -- notify client of failure
            RemoteAlert:FireClient(player, { error = "Teleport failed: "..tostring(err) })
        end
    end)
end)

print("RareBrainrotNotifier server script running (subscribed to "..CHANNEL..")")




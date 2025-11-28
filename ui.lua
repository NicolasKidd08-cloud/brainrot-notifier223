local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner")
if existing then existing:Destroy() end

local UI_W, UI_H = 650, 450
local FULL_SIZE = UDim2.new(0, UI_W, 0, UI_H)
local HEADER_H = 50
local CLOSED_SIZE = UDim2.new(0, UI_W, 0, HEADER_H)

local LEFT_MARGIN = 14
local LEFT_W = 250
local GAP = 14
local RIGHT_X = LEFT_MARGIN + LEFT_W + GAP
local RIGHT_W = UI_W - RIGHT_X - LEFT_MARGIN

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexa Aj"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = FULL_SIZE
Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(28,29,33)
Main.BorderSizePixel = 0
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3

coroutine.wrap(function()
    while true do
        for i = 0, 255 do
            stroke.Color = Color3.fromHSV(i/255, 0.88, 1)
            task.wait(0.02)
        end
    end
end)()

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,HEADER_H)
Header.BackgroundColor3 = Color3.fromRGB(20,20,22)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6,0,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(140,255,150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "Nick and Scrap's Auto Jointer"
Title.Parent = Header

local Discord = Instance.new("TextButton")
Discord.Size = UDim2.new(0,200,1,0)
Discord.Position = UDim2.new(1, -230, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Font = Enum.Font.GothamBold
Discord.TextSize = 14
Discord.TextColor3 = Color3.fromRGB(120,200,255)
Discord.Text = "discord.gg/pAgSFBKj"
Discord.Parent = Header

Discord.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/pAgSFBKj") end
    local old = Discord.Text
    Discord.Text = "Copied!"
    task.wait(1)
    if Discord then Discord.Text = old end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,34,0,34)
ToggleBtn.Position = UDim2.new(1, -40, 0.5, -17)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(236,93,93)
ToggleBtn.Text = ""
ToggleBtn.Parent = Header
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-HEADER_H)
Content.Position = UDim2.new(0,0,0,HEADER_H)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Left = Instance.new("Frame")
Left.Size = UDim2.new(0, LEFT_W, 1, 0)
Left.Position = UDim2.new(0, LEFT_MARGIN, 0, 0)
Left.BackgroundColor3 = Color3.fromRGB(22,23,27)
Left.Parent = Content
Instance.new("UICorner", Left).CornerRadius = UDim.new(0,10)

local leftPad = Instance.new("Frame")
leftPad.Size = UDim2.new(1,-20,1,-24)
leftPad.Position = UDim2.new(0,10,0,12)
leftPad.BackgroundTransparency = 1
leftPad.Parent = Left

local leftLayout = Instance.new("UIListLayout", leftPad)
leftLayout.Padding = UDim.new(0,10)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local featHeader = Instance.new("Frame")
featHeader.Size = UDim2.new(1,0,0,44)
featHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
featHeader.Parent = leftPad
Instance.new("UICorner", featHeader).CornerRadius = UDim.new(0,8)

local featLabel = Instance.new("TextLabel")
featLabel.Size = UDim2.new(1,0,1,0)
featLabel.BackgroundTransparency = 1
featLabel.Font = Enum.Font.GothamBold
featLabel.TextSize = 16
featLabel.Text = "Features"
featLabel.TextColor3 = Color3.fromRGB(245,245,245)
featLabel.Parent = featHeader

local tokenFrame = Instance.new("Frame")
tokenFrame.Size = UDim2.new(1,0,0,98)
tokenFrame.BackgroundTransparency = 1
tokenFrame.Parent = leftPad

local tokenLabel = Instance.new("TextLabel")
tokenLabel.Size = UDim2.new(1,-12,0,18)
tokenLabel.Position = UDim2.new(0,6,0,6)
tokenLabel.BackgroundTransparency = 1
tokenLabel.Font = Enum.Font.Gotham
tokenLabel.TextSize = 13
tokenLabel.TextColor3 = Color3.fromRGB(200,200,200)
tokenLabel.Text = "Discord Token"
tokenLabel.TextXAlignment = Enum.TextXAlignment.Left
tokenLabel.Parent = tokenFrame

local realToken = ""
local updating = false

local tokenBox = Instance.new("TextBox")
tokenBox.Size = UDim2.new(1,-12,0,60)
tokenBox.Position = UDim2.new(0,6,0,28)
tokenBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
tokenBox.TextColor3 = Color3.fromRGB(255,255,255)
tokenBox.Font = Enum.Font.Gotham
tokenBox.TextSize = 12
tokenBox.Text = ""
tokenBox.PlaceholderText = "Paste your Discord token here..."
tokenBox.ClearTextOnFocus = false
tokenBox.MultiLine = true
tokenBox.TextWrapped = true
tokenBox.Parent = tokenFrame
Instance.new("UICorner", tokenBox).CornerRadius = UDim.new(0,8)

tokenBox:GetPropertyChangedSignal("Text"):Connect(function()
    if updating then return end

    local newText = tokenBox.Text
    if #newText < #realToken then
        realToken = realToken:sub(1, #newText)
    elseif #newText > #realToken then
        realToken = realToken .. newText:sub(#realToken + 1)
    end

    updating = true
    tokenBox.Text = string.rep("*", #realToken)
    updating = false
    tokenBox.CursorPosition = #realToken + 1
end)

local btnArea = Instance.new("Frame")
btnArea.Size = UDim2.new(1,0,0,120)
btnArea.BackgroundTransparency = 1
btnArea.Parent = leftPad

local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.92,0,0,42)
AutoBtn.Position = UDim2.new(0.04,0,0,6)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.TextColor3 = Color3.fromRGB(20,20,20)
AutoBtn.Text = "Auto Join"
AutoBtn.Parent = btnArea
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0,8)

local PersBtn = Instance.new("TextButton")
PersBtn.Size = UDim2.new(0.92,0,0,40)
PersBtn.Position = UDim2.new(0.04,0,0,56)
PersBtn.BackgroundColor3 = Color3.fromRGB(56,58,62)
PersBtn.Font = Enum.Font.GothamBold
PersBtn.TextSize = 15
PersBtn.TextColor3 = Color3.fromRGB(235,235,235)
PersBtn.Text = "Persistent Rejoin"
PersBtn.Parent = btnArea
Instance.new("UICorner", PersBtn).CornerRadius = UDim.new(0,8)

local minFrame = Instance.new("Frame")
minFrame.Size = UDim2.new(1,0,0,74)
minFrame.BackgroundTransparency = 1
minFrame.Parent = leftPad

local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(1,-12,0,18)
minLabel.Position = UDim2.new(0,6,0,6)
minLabel.BackgroundTransparency = 1
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 13
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.Text = "Minimum/sec (MS) (in Millions)"
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Parent = minFrame

local minBox = Instance.new("TextBox")
minBox.Size = UDim2.new(1,-12,0,36)
minBox.Position = UDim2.new(0,6,0,28)
minBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
minBox.TextColor3 = Color3.fromRGB(255,255,255)
minBox.Font = Enum.Font.GothamBold
minBox.TextSize = 16
minBox.Text = "10"
minBox.Parent = minFrame
Instance.new("UICorner", minBox).CornerRadius = UDim.new(0,8)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,18)
Status.Position = UDim2.new(0,10,1,-30)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextColor3 = Color3.fromRGB(170,170,170)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Text = "Status: Idle"
Status.Parent = Left

local Right = Instance.new("Frame")
Right.Size = UDim2.new(0, RIGHT_W, 1, 0)
Right.Position = UDim2.new(0, RIGHT_X, 0, 0)
Right.BackgroundColor3 = Color3.fromRGB(30,30,34)
Right.Parent = Content
Instance.new("UICorner", Right).CornerRadius = UDim.new(0,8)

local logsHeader = Instance.new("Frame")
logsHeader.Size = UDim2.new(1,0,0,44)
logsHeader.BackgroundColor3 = Color3.fromRGB(36,36,40)
logsHeader.Parent = Right
Instance.new("UICorner", logsHeader).CornerRadius = UDim.new(0,8)

local logTitle = Instance.new("TextLabel")
logTitle.Size = UDim2.new(1,0,1,0)
logTitle.BackgroundTransparency = 1
logTitle.Font = Enum.Font.GothamBold
logTitle.TextSize = 16
logTitle.TextColor3 = Color3.fromRGB(245,245,245)
logTitle.Text = "Activity Log"
logTitle.Parent = logsHeader

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-60)
Scroll.Position = UDim2.new(0,10,0,50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 6
Scroll.Parent = Right

local logLayout = Instance.new("UIListLayout", Scroll)
logLayout.Padding = UDim.new(0,4)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function AddLog(name, ms)
 local L = Instance.new("Frame")
 L.Size = UDim2.new(1,0,0,32)
 L.BackgroundColor3 = Color3.fromRGB(42,43,47)
 L.Parent = Scroll
 Instance.new("UICorner", L).CornerRadius = UDim.new(0,6)

 local nameLabel = Instance.new("TextLabel")
 nameLabel.Size = UDim2.new(1,-80,1,0)
 nameLabel.Position = UDim2.new(0,10,0,0)
 nameLabel.BackgroundTransparency = 1
 nameLabel.Font = Enum.Font.GothamBold
 nameLabel.TextSize = 14
 nameLabel.TextColor3 = Color3.fromRGB(240,240,240)
 nameLabel.TextXAlignment = Enum.TextXAlignment.Left
 nameLabel.Text = name
 nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
 nameLabel.Parent = L

 local msLabel = Instance.new("TextLabel")
 msLabel.Size = UDim2.new(0,70,1,0)
 msLabel.Position = UDim2.new(1,-75,0,0)
 msLabel.BackgroundTransparency = 1
 msLabel.Font = Enum.Font.GothamBold
 msLabel.TextSize = 14
 msLabel.TextColor3 = Color3.fromRGB(100,200,100)
 msLabel.TextXAlignment = Enum.TextXAlignment.Right
 msLabel.Text = ms
 msLabel.Parent = L

 task.wait()
 Scroll.CanvasSize = UDim2.new(0,0,0,logLayout.AbsoluteContentSize.Y + 10)
 Scroll.CanvasPosition = Vector2.new(0, Scroll.CanvasSize.Y.Offset)
end

local ChannelID = "1401775181025775738"

local function ParseEmbed(embed)
 if not embed or not embed.fields then
  return nil
 end

 local data = {
  Name = nil,
  MoneyPerSec = nil,
  Players = nil,
  JobIdMobile = nil,
  JobIdIOS = nil,
  JobIdPC = nil
 }

 local function CleanJobId(text)
  if not text then return nil end
  text = text:gsub("`", "")
  text = text:gsub("%s+", "")
  text = text:gsub("\n", "")
  text = text:gsub("\r", "")
  if text:match("^[%w%-]+$") and #text > 10 then
   return text
  end
  return nil
 end

 for _, field in pairs(embed.fields) do
  local fieldName = field.name
  local fieldValue = field.value

  if fieldName:find("Name") then
   data.Name = fieldValue

  elseif fieldName:find("Money per sec") then
   local amount = fieldValue:match("%$([%d%.]+)M")
   if amount then
    data.MoneyPerSec = tonumber(amount)
   end

  elseif fieldName:find("Players") then
   data.Players = fieldValue

  elseif fieldName:find("Job ID %(Mobile%)") then
   data.JobIdMobile = CleanJobId(fieldValue)

  elseif fieldName:find("Job ID %(iOS%)") then
   data.JobIdIOS = CleanJobId(fieldValue)

  elseif fieldName:find("Job ID %(PC%)") then
   data.JobIdPC = CleanJobId(fieldValue)
  end
 end

 return data
end

local function FetchDiscordMessages(token, limit)
 limit = limit or 10

 if not token or token == "" then
  warn("No Discord token provided")
  AddLog("Error", "No token")
  return nil
 end

 local success, response = pcall(function()
  return http_request({
   Url = string.format("https://discord.com/api/v10/channels/%s/messages?limit=%d",
     ChannelID, limit),
   Method = "GET",
   Headers = {
    ["Authorization"] = token,
    ["Content-Type"] = "application/json",
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    ["X-Super-Properties"] = "eyJvcyI6IldpbmRvd3MiLCJicm93c2VyIjoiQ2hyb21lIiwiZGV2aWNlIjoiIiwic3lzdGVtX2xvY2FsZSI6ImVuLVVTIiwiYnJvd3Nlcl91c2VyX2FnZW50IjoiTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzEyMC4wLjAuMCBTYWZhcmkvNTM3LjM2IiwiYnJvd3Nlcl92ZXJzaW9uIjoiMTIwLjAuMC4wIiwib3NfdmVyc2lvbiI6IjEwIiwicmVmZXJyZXIiOiIiLCJyZWZlcnJpbmdfZG9tYWluIjoiIiwicmVmZXJyZXJfY3VycmVudCI6IiIsInJlZmVycmluZ19kb21haW5fY3VycmVudCI6IiIsInJlbGVhc2VfY2hhbm5lbCI6InN0YWJsZSIsImNsaWVudF9idWlsZF9udW1iZXIiOjI1ODk3NSwiY2xpZW50X2V2ZW50X3NvdXJjZSI6bnVsbH0=",
    ["X-Discord-Locale"] = "en-US",
    ["X-Debug-Options"] = "bugReporterEnabled",
    ["Origin"] = "https://discord.com",
    ["Referer"] = "https://discord.com/channels/@me"
   }
  })
 end)

 if not success then
  warn("Failed to fetch messages:", response)
  AddLog("Error", "Request failed")
  return nil
 end

 print("Status Code:", response.StatusCode)
 if response.Body then
  print("Response Body:", response.Body:sub(1, 200))
 end

 if response.StatusCode == 401 then
  warn("Invalid Discord token - check your token is correct")
  AddLog("Error", "Invalid token")
  return nil
 end

 if response.StatusCode == 400 then
  warn("Bad request - check token format")
  AddLog("Error", "Bad request")
  return nil
 end

 if response.StatusCode == 429 then
  local retryAfter = 5
  if response.Headers and response.Headers["Retry-After"] then
   retryAfter = tonumber(response.Headers["Retry-After"]) or 5
  end
  warn("Rate limited. Retry after", retryAfter, "seconds")
  AddLog("Rate Limited", retryAfter.."s")
  task.wait(retryAfter)
  return FetchDiscordMessages(token, limit)
 end

 if response.StatusCode ~= 200 then
  warn("Discord API error:", response.StatusCode, response.Body)
  AddLog("API Error", tostring(response.StatusCode))
  return nil
 end

 local messages = HttpService:JSONDecode(response.Body)
 return messages
end

local function GetLatestServers(token, minMoneyPerSec)
 local messages = FetchDiscordMessages(token, 10)
 if not messages then return {} end

 local servers = {}
 minMoneyPerSec = minMoneyPerSec or 10

 for _, message in ipairs(messages) do
  if message.embeds and #message.embeds > 0 then
   for _, embed in ipairs(message.embeds) do
    local serverData = ParseEmbed(embed)
    if serverData and serverData.MoneyPerSec and serverData.MoneyPerSec >= minMoneyPerSec then
     table.insert(servers, serverData)
    end
   end
  end
 end

 return servers
end

local function JoinServerViaChiliHub(jobId)
 if not jobId or jobId == "" then
  warn("Invalid Job ID")
  AddLog("Error", "Invalid ID")
  return false
 end

 AddLog("JobID", jobId:sub(1, 12).."...")

 local success, err = pcall(function()
  local coregui = game:GetService("CoreGui")

  local inputBox = nil
  local joinButton = nil

  for _, gui in pairs(coregui:GetDescendants()) do
   if gui:IsA("TextBox") and gui.Name == "InputBox" then
    local parent = gui.Parent
    if parent and parent.Name == "Input" then
     inputBox = gui
     break
    end
   end
  end

  if not inputBox then
   warn("Could not find InputBox")
   AddLog("Error", "No InputBox")
   return false
  end

  firesignal(inputBox.Focused)
  task.wait(0.1)

  inputBox.Text = jobId

  task.wait(0.3)
  firesignal(inputBox.FocusLost)

  local sectionContent = inputBox.Parent.Parent

  for _, child in ipairs(sectionContent:GetChildren()) do
   if child:FindFirstChild("ButtonInteract") then
    local button = child.ButtonInteract
    if button:IsA("TextButton") and string.find(string.lower(button.Text), "join") then
     for _, connection in pairs(getconnections(button.MouseButton1Click)) do
      connection:Fire()
     end
     AddLog("Joining", "Success")
     return true
    end
   end
  end

  warn("Could not find join button")
  AddLog("Error", "No button")
  return false
 end)

 if not success then
  warn("Failed to join via Chili Hub:", err)
  AddLog("Error", "Join failed")
  return false
 end

 return true
end

local AutoEnabled = false
local PersEnabled = false
local AutoLoop

AutoBtn.MouseButton1Click:Connect(function()
 AutoEnabled = not AutoEnabled

 if AutoEnabled then
  if realToken == "" then
   Status.Text = "Status: No token!"
   AddLog("Error", "No token!")
   AutoEnabled = false
   return
  end

  local minMS = tonumber(minBox.Text) or 10

  AutoBtn.Text = "Working..."
  AutoBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
  Status.Text = "Status: Searching..."

  AutoLoop = task.spawn(function()
   while AutoEnabled do
    local servers = GetLatestServers(realToken, minMS)

    if servers and #servers > 0 then
     for i = #servers, math.max(1, #servers - 2), -1 do
      local server = servers[i]
      AddLog(server.Name or "Unknown", string.format("%.0fM/s", server.MoneyPerSec or 0))
     end

     local server = servers[1]
     Status.Text = string.format("Status: Joining %.0fM/s", server.MoneyPerSec)

     local jobId = server.JobIdPC or server.JobIdIOS or server.JobIdMobile
     if jobId then
      JoinServerViaChiliHub(jobId)
      task.wait(2)
      break
     end
    else
     AddLog("No Servers", "Waiting...")
    end

    task.wait(15)
   end
  end)
 else
  if AutoLoop then
   task.cancel(AutoLoop)
  end

  AutoBtn.Text = "Auto Join"
  AutoBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
  Status.Text = "Status: Idle"
 end
end)

PersBtn.MouseButton1Click:Connect(function()
 PersEnabled = not PersEnabled

 if PersEnabled then
  PersBtn.Text = "Running..."
  PersBtn.BackgroundColor3 = Color3.fromRGB(35,150,85)
 else
  PersBtn.Text = "Persistent Rejoin"
  PersBtn.BackgroundColor3 = Color3.fromRGB(56,58,62)
 end
end)

local Open = true

ToggleBtn.MouseButton1Click:Connect(function()
 Open = not Open

 if Open then
  Content.Visible = true
  TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
   Size = FULL_SIZE
  }):Play()
 else
  TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
   Size = CLOSED_SIZE
  }):Play()

  task.delay(0.23, function()
   if not Open then
    Content.Visible = false
   end
  end)
 end
end)

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = true
  dragStart = i.Position
  startPos = Main.Position
 end
end)

Header.InputChanged:Connect(function(i)
 if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
  local delta = i.Position - dragStart
  Main.Position = UDim2.new(
   startPos.X.Scale, startPos.X.Offset + delta.X,
   startPos.Y.Scale, startPos.Y.Offset + delta.Y
  )
 end
end)

UIS.InputEnded:Connect(function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = false
 end
end)

task.wait(0.5)
AddLog("UI Loaded", "Ready!")
AddLog("Open Chili Hub", "Server Tab")

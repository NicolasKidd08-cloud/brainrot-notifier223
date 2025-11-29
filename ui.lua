local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService") 

local Player = Players.LocalPlayer local PlayerGui = Player:WaitForChild("PlayerGui") 

local existing = PlayerGui:FindFirstChild("NickScrapAutoJoiner") if existing then existing:Destroy() end 

local UI_W, UI_H = 650, 450 local FULL_SIZE = UDim2.new(0, UI_W, 0, UI_H) local HEADER_H = 50 local CLOSED_SIZE = UDim2.new(0, UI_W, 0, HEADER_H) local LEFT_MARGIN = 14 local LEFT_W = 250 local GAP = 14 local RIGHT_X = LEFT_MARGIN + LEFT_W + GAP local RIGHT_W = UI_W - RIGHT_X - LEFT_MARGIN 

local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "NickScrapAutoJoiner" ScreenGui.ResetOnSpawn = false ScreenGui.Parent = PlayerGui 

local Main = Instance.new("Frame") Main.Size = FULL_SIZE Main.Position = UDim2.new(0.5, -UI_W/2, 0.12, 0) Main.BackgroundColor3 = Color3.fromRGB(28,29,33) Main.BorderSizePixel = 0 Main.Name = "MainFrame" Main.Parent = ScreenGui Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10) 

local stroke = Instance.new("UIStroke", Main) stroke.Thickness = 3 

coroutine.wrap(function()    
    while true do        
        for i = 0, 255 do            
            stroke.Color = Color3.fromHSV(i/255, 0.88, 1)            
            task.wait(0.02)        
        end    
    end 
end)()

local Header = Instance.new("Frame") Header.Size = UDim2.new(1,0,0,HEADER_H) Header.BackgroundColor3 = Color3.fromRGB(20,20,22) Header.Parent = Main Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10) 

local Title = Instance.new("TextLabel") Title.Size = UDim2.new(0.6,0,1,0) Title.Position = UDim2.new(0,12,0,0) Title.BackgroundTransparency = 1 Title.Font = Enum.Font.GothamBold Title.TextSize = 18 Title.TextColor3 = Color3.fromRGB(140,255,150) Title.TextXAlignment = Enum.TextXAlignment.Left Title.Text = "Nick and Scrap's Auto Jointer" Title.Parent = Header 

local ToggleBtn = Instance.new("TextButton") ToggleBtn.Size = UDim2.new(0,34,0,34) ToggleBtn.Position = UDim2.new(1, -40, 0.5, -17) ToggleBtn.BackgroundColor3 = Color3.fromRGB(236,93,93) ToggleBtn.Text = "" ToggleBtn.Parent = Header Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0) 

local Content = Instance.new("Frame") Content.Size = UDim2.new(1,0,1,-HEADER_H) Content.Position = UDim2.new(0,0,0,HEADER_H) Content.BackgroundTransparency = 1 Content.Parent = Main 

local Left = Instance.new("Frame") Left.Size = UDim2.new(0, LEFT_W, 1, 0) Left.Position = UDim2.new(0, LEFT_MARGIN, 0, 0) Left.BackgroundColor3 = Color3.fromRGB(22,23,27) Left.Parent = Content Instance.new("UICorner", Left).CornerRadius = UDim.new(0,10) 

local leftPad = Instance.new("Frame") leftPad.Size = UDim2.new(1,-20,1,-24) leftPad.Position = UDim2.new(0,10,0,12) leftPad.BackgroundTransparency = 1 leftPad.Parent = Left 

local leftLayout = Instance.new("UIListLayout", leftPad) leftLayout.Padding = UDim.new(0,10) leftLayout.SortOrder = Enum.SortOrder.LayoutOrder leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 

local featHeader = Instance.new("Frame") featHeader.Size = UDim2.new(1,0,0,44) featHeader.BackgroundColor3 = Color3.fromRGB(36,36,40) featHeader.Parent = leftPad Instance.new("UICorner", featHeader).CornerRadius = UDim.new(0,8) 

local featLabel = Instance.new("TextLabel") featLabel.Size = UDim2.new(1,0,1,0) featLabel.BackgroundTransparency = 1 featLabel.Font = Enum.Font.GothamBold featLabel.TextSize = 16 featLabel.Text = "Features" featLabel.TextColor3 = Color3.fromRGB(245,245,245) featLabel.Parent = featHeader 

local btnArea = Instance.new("Frame") btnArea.Size = UDim2.new(1,0,0,120) btnArea.BackgroundTransparency = 1 btnArea.Parent = leftPad 

local AutoBtn = Instance.new("TextButton") AutoBtn.Size = UDim2.new(0.92,0,0,42) AutoBtn.Position = UDim2.new(0.04,0,0,6) AutoBtn.BackgroundColor3 = Color3.fromRGB(35,150,85) AutoBtn.Font = Enum.Font.GothamBold AutoBtn.TextSize = 16 AutoBtn.TextColor3 = Color3.fromRGB(20,20,20) AutoBtn.Text = "Auto Join" AutoBtn.Parent = btnArea Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0,8) 

local Status = Instance.new("TextLabel") Status.Size = UDim2.new(1,-20,0,18) Status.Position = UDim2.new(0,10,1,-30) Status.BackgroundTransparency = 1 Status.Font = Enum.Font.Gotham Status.TextSize = 13 Status.TextColor3 = Color3.fromRGB(170,170,170) Status.TextXAlignment = Enum.TextXAlignment.Left Status.Text = "Status: Idle" Status.Parent = Left 

local function AddMarker()    
    local char = Player.Character or Player.CharacterAdded:Wait()    
    local marker = Instance.new("BoolValue")    
    marker.Name = "UsingNickScrapUI"    
    marker.Parent = char 
end 

AddMarker()

local ESPs = {} 
RunService.RenderStepped:Connect(function()    
    for _, plr in pairs(Players:GetPlayers()) do        
        if plr == Player then continue end        
        local char = plr.Character        
        if char and char:FindFirstChild("UsingNickScrapUI") then            
            if not ESPs[plr] then                
                local highlight = Instance.new("Highlight")                
                highlight.FillColor = Color3.fromRGB(180,0,255)                
                highlight.OutlineColor = Color3.fromRGB(255,255,255)                
                highlight.FillTransparency = 0.5                
                highlight.OutlineTransparency = 0                
                highlight.Parent = char                
                ESPs[plr] = highlight            
            end        
        else            
            if ESPs[plr] then                
                ESPs[plr]:Destroy()                
                ESPs[plr] = nil            
            end        
        end    
    end 
end)

local Open = true 
ToggleBtn.MouseButton1Click:Connect(function()    
    Open = not Open    
    if Open then        
        Content.Visible = true        
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = FULL_SIZE}):Play()    
    else        
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = CLOSED_SIZE}):Play()        
        task.delay(0.23, function()            
            if not Open then Content.Visible = false end        
        end)    
    end 
end)

local dragging, dragStart, startPos = false, nil, nil 
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
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
end)

Status.Text = "Status: UI Loaded and ESP active"

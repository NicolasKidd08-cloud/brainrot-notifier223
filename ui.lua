-- Replace your old tokenBox creation with this improved version:

local tokenBox = Instance.new("TextBox")
tokenBox.Size = UDim2.new(1,-12,0,36)
tokenBox.Position = UDim2.new(0,6,0,28)
tokenBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
tokenBox.TextColor3 = Color3.fromRGB(255,255,255)
tokenBox.Font = Enum.Font.Gotham
tokenBox.TextSize = 12
tokenBox.ClearTextOnFocus = false
tokenBox.PlaceholderText = "Paste your Discord token here..."
tokenBox.Parent = tokenFrame
Instance.new("UICorner", tokenBox).CornerRadius = UDim.new(0,8)

-- NEW: Token saving & masking system
local TOKEN_FILE = "NickScrap_AutoJoiner_Token.txt"
local MASK = "••••••••••••••••••••••••••••••••" -- 32 bullets (enough for any token)

local function LoadSavedToken()
    if isfile and readfile and isfile(TOKEN_FILE) then
        local saved = readfile(TOKEN_FILE)
        if saved and saved:len() > 20 then  -- basic sanity check
            tokenBox.Text = MASK
            return saved
        end
    end
    return ""
end

local function SaveToken(token)
    if token and token:len() > 20 and not token:find("••••") then
        if writefile then
            writefile(TOKEN_FILE, token)
        end
    end
end

-- Load token on startup
local RealToken = LoadSavedToken()
if RealToken ~= "" then
    tokenBox.Text = MASK
    AddLog("Token Loaded", "Hidden ••••")
else
    tokenBox.Text = ""
end

-- Show real token only while typing
tokenBox.Focused:Connect(function()
    if RealToken ~= "" and tokenBox.Text == MASK then
        tokenBox.Text = RealToken
    end
end)

-- When you click away → hide it again and save if changed
tokenBox.FocusLost:Connect(function(enterPressed)
    local enteredText = tokenBox.Text:gsub("%s", "") -- remove spaces
    
    if enteredText ~= "" and not enteredText:find("••••") then
        RealToken = enteredText
        SaveToken(RealToken)
        tokenBox.Text = MASK
        AddLog("Token Saved", "Now hidden")
    elseif enteredText == "" then
        RealToken = ""
        if isfile and delfile then delfile(TOKEN_FILE) end
        AddLog("Token Cleared", "")
    else
        -- They clicked away without changing → just re-mask
        tokenBox.Text = MASK
    end
end)

-- Optional: Right-click → "Show Token" once (for verification)
tokenBox.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Right click
        if RealToken ~= "" then
            tokenBox.Text = RealToken
            AddLog("Token Visible", "Right-click again to hide")
            task.delay(8, function()
                if tokenBox and tokenBox.Text == RealToken then
                    tokenBox.Text = MASK
                    AddLog("Token Hidden", "Auto-hidden after 8s")
                end
            end)
        end
    end
end)

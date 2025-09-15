--copy for educational purpose only dont copy for sell na nigga

--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N   --Owner : K3N



-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Prevent multiple GUI
if player.PlayerGui:FindFirstChild("AutoUseGUI") then
    warn("GUI already loaded!")
    return
end

-- -------------------------------
-- Core Variables
-- -------------------------------
local autoUseEnabled = false
local espEnabled = false
local USE_DELAY = 0.05
local PLATFORM_SIZE = Vector3.new(10,1,10)
local PLATFORM_HEIGHT = 1000
local platformPart
local groundPosition = nil
local statusText = "Idle"

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end)

-- -------------------------------
-- Functions
-- -------------------------------

-- Use all tools in backpack (equip + activate + deactivate)
local function useAllItems()
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            pcall(function()
                humanoid:EquipTool(tool)
                tool:Activate()
                task.wait(0.01)
                tool:Deactivate()
            end)
        end
    end
end

-- Platform create/remove
local function createPlatform()
    if platformPart then platformPart:Destroy() end
    platformPart = Instance.new("Part")
    platformPart.Size = PLATFORM_SIZE
    platformPart.Anchored = true
    platformPart.Position = hrp.Position - Vector3.new(0, hrp.Size.Y/2 + 0.5, 0)
    platformPart.CanCollide = true
    platformPart.Material = Enum.Material.SmoothPlastic
    platformPart.Name = "SafePlatform"
    platformPart.Parent = Workspace
end

local function removePlatform()
    if platformPart then
        pcall(function() platformPart:Destroy() end)
        platformPart = nil
    end
end

-- Tween HRP to position
local function tweenTo(position, duration)
    if not hrp then return end
    local ok, tween = pcall(function()
        return TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(position)})
    end)
    if ok and tween then
        tween:Play()
        pcall(function() tween.Completed:Wait() end)
    end
end

-- Auto-use loop
coroutine.wrap(function()
    task.wait(0.5)
    while true do
        if autoUseEnabled and platformPart and hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(platformPart.Position + Vector3.new(0,3,0))
            useAllItems()
            statusText = "Farming"
        else
            statusText = "Idle"
        end
        task.wait(USE_DELAY)
    end
end)()

-- -------------------------------
-- GUI
-- -------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUseGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(1,-260,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Stylish touches
local frameCorner = Instance.new("UICorner"); frameCorner.CornerRadius = UDim.new(0,12); frameCorner.Parent = frame
local frameStroke = Instance.new("UIStroke"); frameStroke.Thickness = 1.6; frameStroke.Transparency = 0.55; frameStroke.Color = Color3.fromRGB(90,90,120); frameStroke.Parent = frame
local frameGrad = Instance.new("UIGradient"); frameGrad.Parent = frame
frameGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(45,45,60))}

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "K HUB"
titleLabel.Size = UDim2.new(0.7,0,0,35)
titleLabel.Position = UDim2.new(0.15,0,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(0,5,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", closeBtn).Thickness = 1; Instance.new("UIStroke", closeBtn).Transparency = 0.6

-- Hide button
local hideBtn = Instance.new("TextButton")
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(1,-65,0,5)
hideBtn.BackgroundColor3 = Color3.fromRGB(50,50,80)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14
hideBtn.Parent = frame
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", hideBtn).Thickness = 1; Instance.new("UIStroke", hideBtn).Transparency = 0.6

-- Auto-use button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,160,0,60)
toggleBtn.Position = UDim2.new(0.5,-80,0,50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Text = "ปิดดดด"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", toggleBtn).Thickness = 1.2; Instance.new("UIStroke", toggleBtn).Transparency = 0.6

-- ESP button
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0,160,0,40)
espBtn.Position = UDim2.new(0.5,-80,0,120)
espBtn.BackgroundColor3 = Color3.fromRGB(90,90,130)
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.Text = "ESP OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 20
espBtn.Parent = frame
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", espBtn).Thickness = 1; Instance.new("UIStroke", espBtn).Transparency = 0.6

-- Hyper Performance Button
local perfBtn = Instance.new("TextButton")
perfBtn.Size = UDim2.new(0,160,0,40)
perfBtn.Position = UDim2.new(0.5,-80,0,170)
perfBtn.BackgroundColor3 = Color3.fromRGB(180,120,40)
perfBtn.TextColor3 = Color3.fromRGB(255,255,255)
perfBtn.Text = "Ultra Boost"
perfBtn.Font = Enum.Font.GothamBold
perfBtn.TextSize = 16
perfBtn.Parent = frame
Instance.new("UICorner", perfBtn).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", perfBtn).Thickness = 1; Instance.new("UIStroke", perfBtn).Transparency = 0.6

-- Player Info Frame
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1,0,0,70)
profileFrame.Position = UDim2.new(0,0,1,-70)
profileFrame.BackgroundTransparency = 0.3
profileFrame.BackgroundColor3 = Color3.fromRGB(45,45,60)
profileFrame.Parent = frame
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", profileFrame).Thickness = 1; Instance.new("UIStroke", profileFrame).Transparency = 0.7

-- Profile Picture
local thumb = Instance.new("ImageLabel")
thumb.Size = UDim2.new(0,50,0,50)
thumb.Position = UDim2.new(0,10,0,10)
thumb.BackgroundTransparency = 1
thumb.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
thumb.Parent = profileFrame
Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,8)

-- Username
local nameLabel = Instance.new("TextLabel")
nameLabel.Position = UDim2.new(0,70,0,10)
nameLabel.Size = UDim2.new(0,160,0,15)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Name: "..player.Name
nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = profileFrame

-- User ID
local idLabel = Instance.new("TextLabel")
idLabel.Position = UDim2.new(0,70,0,27)
idLabel.Size = UDim2.new(0,160,0,15)
idLabel.BackgroundTransparency = 1
idLabel.Text = "ID: "..player.UserId
idLabel.TextColor3 = Color3.fromRGB(200,200,200)
idLabel.Font = Enum.Font.GothamBold
idLabel.TextSize = 14
idLabel.TextXAlignment = Enum.TextXAlignment.Left
idLabel.Parent = profileFrame

-- Game Name
local gameLabel = Instance.new("TextLabel")
gameLabel.Position = UDim2.new(0,70,0,44)
gameLabel.Size = UDim2.new(0,160,0,20)
gameLabel.BackgroundTransparency = 1
local success, productInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
gameLabel.Text = "Game: "..(success and productInfo.Name or "Unknown")
gameLabel.TextColor3 = Color3.fromRGB(200,200,255)
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextSize = 13
gameLabel.TextWrapped = true
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = profileFrame

-- -------------------------------
-- Hover Effects
-- -------------------------------
local function addHoverTween(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
        end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = normalColor}):Play()
        end)
    end)
end
addHoverTween(hideBtn, Color3.fromRGB(50,50,80), Color3.fromRGB(65,65,100))
addHoverTween(closeBtn, Color3.fromRGB(200,50,50), Color3.fromRGB(220,70,70))
addHoverTween(toggleBtn, Color3.fromRGB(60,120,60), Color3.fromRGB(80,150,80))
addHoverTween(espBtn, Color3.fromRGB(90,90,130), Color3.fromRGB(110,110,160))
addHoverTween(perfBtn, Color3.fromRGB(180,120,40), Color3.fromRGB(210,150,60))

-- -------------------------------
-- Button Logic
-- -------------------------------
toggleBtn.MouseButton1Click:Connect(function()
    autoUseEnabled = not autoUseEnabled
    toggleBtn.Text = autoUseEnabled and "ฟามมม" or "ปิดดดด"
    if autoUseEnabled then
        groundPosition = hrp and hrp.Position or nil
        if hrp then tweenTo(hrp.Position + Vector3.new(0, PLATFORM_HEIGHT, 0), 0.5) end
        createPlatform()
    else
        removePlatform()
        if groundPosition and hrp then tweenTo(Vector3.new(hrp.Position.X, groundPosition.Y, hrp.Position.Z), 0.5) end
    end
end)

-- Hide/Show Logic
hideBtn.MouseButton1Click:Connect(function()
    local hidden = toggleBtn.Visible
    if hidden then
        toggleBtn.Visible = false
        espBtn.Visible = false
        perfBtn.Visible = false
        profileFrame.Visible = false
        frame.Size = UDim2.new(0,250,0,35)
        hideBtn.Text = "Show"
    else
        toggleBtn.Visible = true
        espBtn.Visible = true
        perfBtn.Visible = true
        profileFrame.Visible = true
        frame.Size = UDim2.new(0,250,0,300)
        hideBtn.Text = "Hide"
    end
end)

-- Close GUI
closeBtn.MouseButton1Click:Connect(function()
    autoUseEnabled = false
    espEnabled = false
    removePlatform()
    -- destroy GUI safely
    if screenGui and screenGui.Parent then screenGui:Destroy() end
end)

-- -------------------------------
-- ESP Logic
-- -------------------------------
local espLabels = {}
local espConnections = {}

local function clearESP()
    for _, gui in pairs(espLabels) do
        pcall(function() gui:Destroy() end)
    end
    espLabels = {}
    for _, conn in pairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
end

local function addESP(p)
    if p == player then return end
    local function setupChar(char)
        task.wait(0.1)
        if not char or not char.Parent then return end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then return end
        if espLabels[p] then pcall(function() espLabels[p]:Destroy() end) espLabels[p]=nil end

        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0,150,0,50)
        bill.Adornee = head
        bill.AlwaysOnTop = true
        bill.Name = "ESPLabel"
        bill.Parent = char

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 0.5
        label.BackgroundColor3 = Color3.fromRGB(0,0,0)
        label.TextColor3 = Color3.fromRGB(0,255,0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextStrokeTransparency = 0
        label.Parent = bill

        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local function update()
                label.Text = p.Name.." | HP: "..math.floor(hum.Health).."%"
            end
            update()
            local hc = hum.HealthChanged:Connect(update)
            table.insert(espConnections, hc)
        else
            label.Text = p.Name
        end

        espLabels[p] = bill
    end
    if p.Character then setupChar(p.Character) end
    local ca = p.CharacterAdded:Connect(setupChar)
    table.insert(espConnections, ca)
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ON" or "ESP OFF"

    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do pcall(function() addESP(p) end) end
        local pa = Players.PlayerAdded:Connect(function(p) pcall(function() addESP(p) end) end)
        table.insert(espConnections, pa)
    else
        clearESP()
    end
end)

-- -------------------------------
-- Status Watermark
-- -------------------------------
local watermark = Drawing.new("Text")
watermark.Size = 25
watermark.Outline = true
watermark.Center = false
watermark.Font = 2
watermark.Thickness = 4
local lastTime = tick()
local fps = 0

RunService.RenderStepped:Connect(function(deltaTime)
    fps = math.floor(1 / deltaTime) -- Calculate FPS
    local camera = Workspace.CurrentCamera
    local screenSize = camera and camera.ViewportSize or Vector2.new(1920,1080)
    local timeStr = os.date("%H:%M:%S")
    watermark.Position = Vector2.new(screenSize.X-300, 10)
    watermark.Text = "[Status: "..statusText.."] | FPS: "..fps.." | "..timeStr
    watermark.Color = Color3.fromRGB(49,232,82)
end)

-- -------------------------------
-- Hyper Performance Button Logic
-- -------------------------------
perfBtn.MouseButton1Click:Connect(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Boost Performance",
        Text = "Are you sure you want to apply Ultra Boost? Low graphics, blocks only. Yes/No",
        Duration = 60,
        Callback = function(response)
          
        end
    })

    -- Create custom notification
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0,300,0,120)
    notifFrame.Position = UDim2.new(0.5,-150,0.5,-60)
    notifFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    notifFrame.Parent = screenGui
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0,10)

    local notifText = Instance.new("TextLabel")
    notifText.Text = "Are you sure you want to apply Ultra Boost?\nLow graphics, blocks only."
    notifText.Size = UDim2.new(1,0,0.6,0)
    notifText.Position = UDim2.new(0,0,0,0)
    notifText.BackgroundTransparency = 1
    notifText.TextColor3 = Color3.fromRGB(255,255,255)
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 16
    notifText.TextWrapped = true
    notifText.Parent = notifFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Text = "YES"
    yesBtn.Size = UDim2.new(0.45,0,0.25,0)
    yesBtn.Position = UDim2.new(0.05,0,0.65,0)
    yesBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
    yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 18
    yesBtn.Parent = notifFrame
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,8)

    local noBtn = Instance.new("TextButton")
    noBtn.Text = "NO"
    noBtn.Size = UDim2.new(0.45,0,0.25,0)
    noBtn.Position = UDim2.new(0.5,0,0.65,0)
    noBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
    noBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 18
    noBtn.Parent = notifFrame
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,8)

    -- Buttons functionality
    yesBtn.MouseButton1Click:Connect(function()
        notifFrame:Destroy()
        -- Apply Hyper Performance
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 9e9
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)

        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end

        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterTransparency = 1
            terrain.WaterReflectance = 0
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
        end

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") 
            or obj:IsA("Trail") 
            or obj:IsA("Fire") 
            or obj:IsA("Smoke") 
            or obj:IsA("Explosion")
            or obj:IsA("Decal") 
            or obj:IsA("Texture")
            then
                obj:Destroy()
            elseif obj:IsA("MeshPart") then
                obj.Material = Enum.Material.Plastic
                obj.TextureID = ""
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, item in pairs(plr.Character:GetDescendants()) do
                    if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("Clothing") or item:IsA("ShirtGraphic") then
                        item:Destroy()
                    elseif item:IsA("MeshPart") then
                        item.Material = Enum.Material.Plastic
                        item.TextureID = ""
                    end
                end
            end
        end

        for _, anim in pairs(Workspace:GetDescendants()) do
            if anim:IsA("AnimationController") or anim:IsA("Animator") then
                anim:Destroy()
            end
        end

        if setfpscap then setfpscap(240) end

        task.spawn(function()
            while task.wait(5) do collectgarbage("collect") end
        end)

        StarterGui:SetCore("SendNotification", {Title = "💨 Ultra Boost Activated", Text = "Blocks Only | Max FPS | Potato Approved", Duration = 3})
    end)

    noBtn.MouseButton1Click:Connect(function()
        notifFrame:Destroy()
    end)
end)


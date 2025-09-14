--copy for educational purpose only dont copy for sell na nigga

--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N --Owner : K3N  --Owner : K3N
--Owner : K3N  --Owner : K3N--Owner : K3N  --Owner : K3N--Owner : K3N   --Owner : K3N

-- Services
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Loading...";
    Text = "Made by k3n";
    Icon = "http://www.roblox.com/asset/?id=9808242819";
    Duration = 5;
})
wait(3)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- Prevent multiple GUI
if player.PlayerGui:FindFirstChild("AutoUseGUI") then
	warn("GUI already loaded!")
	return
end
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Loaded!";
    Text = "Enjoy:3";
    Icon = "http://www.roblox.com/asset/?id=9808242819";
    Duration = 5;
})


local autoUseEnabled = false
local espEnabled = false
local USE_DELAY = 0.05
local PLATFORM_SIZE = Vector3.new(10,1,10)
local PLATFORM_HEIGHT = 1000
local platformPart
local groundPosition = nil

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	hrp = character:WaitForChild("HumanoidRootPart")
end)

local function useAllItems()
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			pcall(function()
				humanoid:EquipTool(tool)
				tool:Activate()
				tool:Deactivate()
			end)
		end
	end
end

local function createPlatform()
	platformPart = Instance.new("Part")
	platformPart.Size = PLATFORM_SIZE
	platformPart.Anchored = true
	platformPart.Position = hrp.Position - Vector3.new(0, hrp.Size.Y/2 + 0.5, 0)
	platformPart.CanCollide = true
	platformPart.Material = Enum.Material.SmoothPlastic
	platformPart.Name = "SafePlatform"
	platformPart.Parent = workspace
end

local function removePlatform()
	if platformPart then
		platformPart:Destroy()
		platformPart = nil
	end
end

local function tweenTo(position, duration)
	local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(position)})
	tween:Play()
	tween.Completed:Wait()
end

-- Auto-use loop
coroutine.wrap(function()
	task.wait(0.5)
	while true do
		if autoUseEnabled and platformPart then
			hrp.CFrame = CFrame.new(platformPart.Position + Vector3.new(0,3,0))
			useAllItems()
		end
		task.wait(USE_DELAY)
	end
end)()

-- ===============================
-- SECTION 2: GUI
-- ===============================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUseGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(1,-260,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

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

-- Hide button (next to title)
local hideBtn = Instance.new("TextButton")
hideBtn.Text = "Hide"
hideBtn.Size = UDim2.new(0,60,0,30)
hideBtn.Position = UDim2.new(1,-65,0,5)
hideBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14
hideBtn.Parent = frame

-- Close button (top-left corner)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(0,5,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = frame

-- Auto-use button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,160,0,60)
toggleBtn.Position = UDim2.new(0.5,-80,0,50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Text = "ปิดดดด"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.Parent = frame

-- Player ESP button
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0,160,0,40)
espBtn.Position = UDim2.new(0.5,-80,0,120)
espBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.Text = "ESP OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 20
espBtn.Parent = frame

-- Profile info
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1,0,0,70)
profileFrame.Position = UDim2.new(0,0,1,-70)
profileFrame.BackgroundTransparency = 1
profileFrame.Parent = frame

-- Profile picture
local thumb = Instance.new("ImageLabel")
thumb.Size = UDim2.new(0,50,0,50)
thumb.Position = UDim2.new(0,10,0,10)
thumb.BackgroundTransparency = 1
thumb.Parent = profileFrame
thumb.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"

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
idLabel.TextColor3 = Color3.fromRGB(255,255,255)
idLabel.Font = Enum.Font.GothamBold
idLabel.TextSize = 14
idLabel.TextXAlignment = Enum.TextXAlignment.Left
idLabel.Parent = profileFrame

-- Game name
local gameLabel = Instance.new("TextLabel")
gameLabel.Position = UDim2.new(0,70,0,44)
gameLabel.Size = UDim2.new(0,160,0,20)
gameLabel.BackgroundTransparency = 1
local success, productInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local gameName = success and productInfo.Name or "Unknown"
gameLabel.Text = "Game: "..gameName
gameLabel.TextColor3 = Color3.fromRGB(255,255,255)
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextSize = 13
gameLabel.TextWrapped = true
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = profileFrame

-- ===============================
-- BUTTON FUNCTIONS
-- ===============================

toggleBtn.MouseButton1Click:Connect(function()
	autoUseEnabled = not autoUseEnabled
	toggleBtn.Text = autoUseEnabled and "ฟามมม" or "ปิดดดด"
	if autoUseEnabled then
		groundPosition = hrp.Position
		tweenTo(hrp.Position + Vector3.new(0, PLATFORM_HEIGHT, 0),0.5)
		createPlatform()
	else
		removePlatform()
		if groundPosition then
			tweenTo(Vector3.new(hrp.Position.X, groundPosition.Y, hrp.Position.Z),0.5)
		end
	end
end)

-- ESP
local espLabels = {}
local function addESP(p)
	if p == player then return end
	if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end

	local bill = Instance.new("BillboardGui")
	bill.Size = UDim2.new(0,150,0,50)
	bill.Adornee = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
	bill.AlwaysOnTop = true
	bill.Name = "ESPLabel"
	bill.Parent = p.Character

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 0.5
	label.BackgroundColor3 = Color3.fromRGB(0,0,0)
	label.TextColor3 = Color3.fromRGB(0,255,0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextStrokeTransparency = 0
	label.Parent = bill

	local hum = p.Character:FindFirstChild("Humanoid")
	if hum then
		hum.HealthChanged:Connect(function()
			label.Text = p.Name.." | HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
		end)
		label.Text = p.Name.." | HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
	end

	espLabels[p] = bill
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP ON" or "ESP OFF"

	if espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			addESP(p)
		end
		Players.PlayerAdded:Connect(function(p)
			p.CharacterAdded:Connect(function()
				if espEnabled then addESP(p) end
			end)
		end)
	else
		for _, bill in pairs(espLabels) do
			if bill then bill:Destroy() end
		end
		espLabels = {}
	end
end)

-- Hide button function
hideBtn.MouseButton1Click:Connect(function()
	local hidden = toggleBtn.Visible
	if hidden then
		toggleBtn.Visible = false
		espBtn.Visible = false
		profileFrame.Visible = false
		frame.Size = UDim2.new(0,250,0,35)
		hideBtn.Text = "Show"
	else
		toggleBtn.Visible = true
		espBtn.Visible = true
		profileFrame.Visible = true
		frame.Size = UDim2.new(0,250,0,300)
		hideBtn.Text = "Hide"
	end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	autoUseEnabled = false
	espEnabled = false
	removePlatform()
	for _, bill in pairs(espLabels) do if bill then bill:Destroy() end end
	espLabels = {}
	if watermark then watermark:Remove() end 
	screenGui:Destroy() 
end)

-- ===============================
-- SECTION 3: Watermark
-- ===============================

local watermarkText = "Status"
local watermark = Drawing.new("Text")
watermark.Size = 25
watermark.Outline = true
watermark.Center = false
watermark.Font = 2
watermark.Thickness = 4

local lastTime = tick()
local frames = 0
local fps = 0
local cachedPosition = nil

local function getGradientColor(t)
	return Color3.new(math.sin(t*0.5)*0.5+0.5, math.sin(t*0.5+2)*0.5+0.5, math.sin(t*0.5+4)*0.5+0.5)
end

coroutine.wrap(function()
	task.wait(1)
	RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		if not camera then return end
		frames +=1
		local now = tick()
		if now - lastTime >=1 then
			fps = frames
			frames =0
			lastTime = now
		end
		local timeStr = os.date("%H:%M:%S")
		local t = tick()
		watermark.Color = getGradientColor(t)
		watermark.Text = string.format("%s | Time: %s | FPS: %d",watermarkText,timeStr,fps)
		if not cachedPosition then
			local screenSize = camera.ViewportSize
			local padding = 15
			local textBounds = watermark.TextBounds
			cachedPosition = Vector2.new(screenSize.X - textBounds.X - padding,padding+10)
		end
		watermark.Position = cachedPosition
	end)
end)()
wait(7.5)
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Sometimes glitch";
    Text = "still in testing";
    Icon = "http://www.roblox.com/asset/?id=9808242819";
    Duration = 3;
})

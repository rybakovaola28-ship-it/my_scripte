-- Создаем интерфейс
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("RocketBlueMenu")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RocketBlueMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Кнопка открытия
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleButton.Text = "R"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
ToggleButton.BorderSizePixel = 0
local btnCorner = Instance.new("UICorner"); btnCorner.CornerRadius = UDim.new(1, 0); btnCorner.Parent = ToggleButton

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 520)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
local menuCorner = Instance.new("UICorner"); menuCorner.CornerRadius = UDim.new(0, 10); menuCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROCKET BLUE HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18

-- ЛОГИКА ПЕРЕТАСКИВАНИЯ МЕНЮ
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ESP
local espEnabled = false
local espObjects = {}
local function createESP(character, color)
    if character and character:FindFirstChild("HumanoidRootPart") then
        if espObjects[character] then espObjects[character]:Destroy() end
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espObjects[character] = highlight
    end
end
local function updateESP()
    if not espEnabled then return end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            local color = (p == player) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            createESP(p.Character, color)
            p.CharacterAdded:Connect(function(newChar)
                task.wait(1)
                if espEnabled then createESP(newChar, color) end
            end)
        end
    end
end
local function clearESP()
    for char, highlight in pairs(espObjects) do if highlight then highlight:Destroy() end end
    espObjects = {}
end

-- AIMBOT
local aimbotEnabled = false
local aimbotSpeed = 0.3
local aimbotTargetName = ""

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local camera = workspace.CurrentCamera
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if aimbotTargetName ~= "" and string.lower(p.Name) ~= string.lower(aimbotTargetName) then continue end
            local rootPart = p.Character.HumanoidRootPart
            local screenPoint, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local centerX, centerY = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
                local distance = math.sqrt((screenPoint.X - centerX)^2 + (screenPoint.Y - centerY)^2)
                if distance < shortestDistance then shortestDistance = distance; closestPlayer = p end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local currentCFrame = workspace.CurrentCamera.CFrame
            local desiredCFrame = CFrame.new(currentCFrame.Position, targetPos)
            workspace.CurrentCamera.CFrame = currentCFrame:Lerp(desiredCFrame, aimbotSpeed)
        end
    end
end)

-- FLY (Исправленный)
local flyEnabled = false
local flySpeed = 50
local flyConnection

local function startFly()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    humanoid.PlatformStand = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = rootPart
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not character or not character.Parent then
            if bodyVelocity then bodyVelocity:Destroy() end
            if flyConnection then flyConnection:Disconnect() end
            return
        end

        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end

        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end)
end

local function stopFly()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    if flyConnection then flyConnection:Disconnect() end
end

-- КНОПКИ МЕНЮ
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = MainFrame
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0.1, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
SpeedButton.Text = "Включить бесконечный прыжок"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.Gotham
SpeedButton.TextSize = 14
local speedCorner = Instance.new("UICorner"); speedCorner.CornerRadius = UDim.new(0, 5); speedCorner.Parent = SpeedButton

local EspButton = Instance.new("TextButton")
EspButton.Parent = MainFrame
EspButton.Size = UDim2.new(0.9, 0, 0, 35)
EspButton.Position = UDim2.new(0.05, 0, 0.2, 0)
EspButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
EspButton.Text = "Включить ESP (Подсветку)"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.Gotham
EspButton.TextSize = 14
local espCorner = Instance.new("UICorner"); espCorner.CornerRadius = UDim.new(0, 5); espCorner.Parent = EspButton

local AimbotButton = Instance.new("TextButton")
AimbotButton.Parent = MainFrame
AimbotButton.Size = UDim2.new(0.9, 0, 0, 35)
AimbotButton.Position = UDim2.new(0.05, 0, 0.3, 0)
AimbotButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
AimbotButton.Text = "Включить Aimbot (ПКМ)"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.Font = Enum.Font.Gotham
AimbotButton.TextSize = 14
local aimCorner = Instance.new("UICorner"); aimCorner.CornerRadius = UDim.new(0, 5); aimCorner.Parent = AimbotButton

local AimSettingsText = Instance.new("TextLabel")
AimSettingsText.Parent = MainFrame
AimSettingsText.Size = UDim2.new(0.9, 0, 0, 20)
AimSettingsText.Position = UDim2.new(0.05, 0, 0.4, 0)
AimSettingsText.BackgroundTransparency = 1
AimSettingsText.Text = "Настройки Аимбота:"
AimSettingsText.TextColor3 = Color3.fromRGB(0, 150, 255)
AimSettingsText.Font = Enum.Font.GothamBold
AimSettingsText.TextSize = 14
AimSettingsText.TextXAlignment = Enum.TextXAlignment.Left

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Parent = MainFrame
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 30)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.46, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedSlider.Text = "Скорость наведения: 0.3"
SpeedSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.TextSize = 13
local sliderCorner = Instance.new("UICorner"); sliderCorner.CornerRadius = UDim.new(0, 5); sliderCorner.Parent = SpeedSlider

local TargetBox = Instance.new("TextBox")
TargetBox.Parent = MainFrame
TargetBox.Size = UDim2.new(0.9, 0, 0, 30)
TargetBox.Position = UDim2.new(0.05, 0, 0.54, 0)
TargetBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TargetBox.PlaceholderText = "Имя цели (пусто = все)"
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.Font = Enum.Font.Gotham
TargetBox.TextSize = 13
local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 5); boxCorner.Parent = TargetBox

local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.Size = UDim2.new(0.9, 0, 0, 35)
FlyButton.Position = UDim2.new(0.05, 0, 0.64, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
FlyButton.Text = "Включить Fly (Полёт)"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.Gotham
FlyButton.TextSize = 14
local flyCorner = Instance.new("UICorner"); flyCorner.CornerRadius = UDim.new(0, 5); flyCorner.Parent = FlyButton

local FlySettingsText = Instance.new("TextLabel")
FlySettingsText.Parent = MainFrame
FlySettingsText.Size = UDim2.new(0.9, 0, 0, 20)
FlySettingsText.Position = UDim2.new(0.05, 0, 0.74, 0)
FlySettingsText.BackgroundTransparency = 1
FlySettingsText.Text = "Настройки Полёта:"
FlySettingsText.TextColor3 = Color3.fromRGB(0, 150, 255)
FlySettingsText.Font = Enum.Font.GothamBold
FlySettingsText.TextSize = 14
FlySettingsText.TextXAlignment = Enum.TextXAlignment.Left

local FlySpeedSlider = Instance.new("TextButton")
FlySpeedSlider.Parent = MainFrame
FlySpeedSlider.Size = UDim2.new(0.9, 0, 0, 30)
FlySpeedSlider.Position = UDim2.new(0.05, 0, 0.8, 0)
FlySpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FlySpeedSlider.Text = "Скорость полёта: 50"
FlySpeedSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
FlySpeedSlider.Font = Enum.Font.Gotham
FlySpeedSlider.TextSize = 13
local flySliderCorner = Instance.new("UICorner"); flySliderCorner.CornerRadius = UDim.new(0, 5); flySliderCorner.Parent = FlySpeedSlider

-- ОБРАБОТЧИКИ НАЖАТИЙ
local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

SpeedButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    SpeedButton.Text = infiniteJumpEnabled and "Выключить бесконечный прыжок" or "Включить бесконечный прыжок"
    SpeedButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
end)

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspButton.Text = espEnabled and "Выключить ESP (Подсветку)" or "Включить ESP (Подсветку)"
    EspButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
    if espEnabled then updateESP() else clearESP() end
end)

AimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotButton.Text = aimbotEnabled and "Aimbot: ВКЛ (Зажми ПКМ)" or "Включить Aimbot (ПКМ)"
    AimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
end)

local speeds = {0.1, 0.2, 0.3, 0.4, 0.5, 0.7, 0.9, 1.0}
local currentSpeedIndex = 3
SpeedSlider.MouseButton1Click:Connect(function()
    currentSpeedIndex = currentSpeedIndex + 1
    if currentSpeedIndex > #speeds then currentSpeedIndex = 1 end
    aimbotSpeed = speeds[currentSpeedIndex]
    SpeedSlider.Text = "Скорость наведения: " .. tostring(aimbotSpeed)
end)

TargetBox.FocusLost:Connect(function()
    aimbotTargetName = TargetBox.Text
end)

FlyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        FlyButton.Text = "Выключить Fly (Полёт)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        startFly()
    else
        FlyButton.Text = "Включить Fly (Полёт)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        stopFly()
    end
end)

local flySpeeds = {20, 50, 100, 200, 300}
local currentFlySpeedIndex = 2
FlySpeedSlider.MouseButton1Click:Connect(function()
    currentFlySpeedIndex = currentFlySpeedIndex + 1
    if currentFlySpeedIndex > #flySpeeds then currentFlySpeedIndex = 1 end
    flySpeed = flySpeeds[currentFlySpeedIndex]
    FlySpeedSlider.Text = "Скорость полёта: " .. tostring(flySpeed)
end)

-- АНИМАЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ
local TweenService = game:GetService("TweenService")
local function OpenMenu()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 520)})
    tween:Play()
end
local function CloseMenu()
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end
ToggleButton.MouseButton1Click:Connect(OpenMenu)
CloseButton.MouseButton1Click:Connect(CloseMenu)

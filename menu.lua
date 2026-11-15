-- Создаем интерфейс
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("RocketBlueMenu")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RocketBlueMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Кнопка открытия (Фиолетовая)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Фиолетовый
ToggleButton.Text = "R"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
ToggleButton.BorderSizePixel = 0
local btnCorner = Instance.new("UICorner"); btnCorner.CornerRadius = UDim.new(1, 0); btnCorner.Parent = ToggleButton

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30) -- Темно-фиолетовый фон
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
local menuCorner = Instance.new("UICorner"); menuCorner.CornerRadius = UDim.new(0, 10); menuCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Фиолетовая шапка
TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROCKET PURPLE HUB"
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

-- Кнопки вкладок
local TabButton1 = Instance.new("TextButton")
TabButton1.Parent = MainFrame
TabButton1.Size = UDim2.new(0.31, 0, 0, 25)
TabButton1.Position = UDim2.new(0.02, 0, 0.1, 0)
TabButton1.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
TabButton1.Text = "Функции"
TabButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton1.Font = Enum.Font.GothamBold
TabButton1.TextSize = 11
TabButton1.BorderSizePixel = 0
local tab1Corner = Instance.new("UICorner"); tab1Corner.CornerRadius = UDim.new(0, 5); tab1Corner.Parent = TabButton1

local TabButton2 = Instance.new("TextButton")
TabButton2.Parent = MainFrame
TabButton2.Size = UDim2.new(0.31, 0, 0, 25)
TabButton2.Position = UDim2.new(0.34, 0, 0.1, 0)
TabButton2.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
TabButton2.Text = "Аим и ESP"
TabButton2.TextColor3 = Color3.fromRGB(200, 200, 200)
TabButton2.Font = Enum.Font.GothamBold
TabButton2.TextSize = 11
TabButton2.BorderSizePixel = 0
local tab2Corner = Instance.new("UICorner"); tab2Corner.CornerRadius = UDim.new(0, 5); tab2Corner.Parent = TabButton2

local TabButton3 = Instance.new("TextButton")
TabButton3.Parent = MainFrame
TabButton3.Size = UDim2.new(0.31, 0, 0, 25)
TabButton3.Position = UDim2.new(0.66, 0, 0.1, 0)
TabButton3.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
TabButton3.Text = "Настройки"
TabButton3.TextColor3 = Color3.fromRGB(200, 200, 200)
TabButton3.Font = Enum.Font.GothamBold
TabButton3.TextSize = 11
TabButton3.BorderSizePixel = 0
local tab3Corner = Instance.new("UICorner"); tab3Corner.CornerRadius = UDim.new(0, 5); tab3Corner.Parent = TabButton3

-- ЛОГИКА ПЕРЕТАСКИВАНИЯ
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local dragging = false
local dragInput, dragStart, startPos

local function setupDrag(object)
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if object:IsA("TextButton") or object:IsA("TextBox") or object:IsA("ScrollingFrame") then return end
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
end
setupDrag(TopBar)

UserInputService.InputChanged:Connect(function(input)
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

-- СКРОЛЛ-ФРЕЙМЫ
local Page1 = Instance.new("ScrollingFrame")
Page1.Parent = MainFrame
Page1.Size = UDim2.new(0.95, 0, 0.8, 0)
Page1.Position = UDim2.new(0.025, 0, 0.2, 0)
Page1.BackgroundTransparency = 1
Page1.BorderSizePixel = 0
Page1.ScrollBarThickness = 4
Page1.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
Page1.Visible = true

local Page2 = Instance.new("ScrollingFrame")
Page2.Parent = MainFrame
Page2.Size = UDim2.new(0.95, 0, 0.8, 0)
Page2.Position = UDim2.new(0.025, 0, 0.2, 0)
Page2.BackgroundTransparency = 1
Page2.BorderSizePixel = 0
Page2.ScrollBarThickness = 4
Page2.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
Page2.Visible = false

local Page3 = Instance.new("ScrollingFrame")
Page3.Parent = MainFrame
Page3.Size = UDim2.new(0.95, 0, 0.8, 0)
Page3.Position = UDim2.new(0.025, 0, 0.2, 0)
Page3.BackgroundTransparency = 1
Page3.BorderSizePixel = 0
Page3.ScrollBarThickness = 4
Page3.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
Page3.Visible = false

local function switchTab(tab)
    Page1.Visible = false; Page2.Visible = false; Page3.Visible = false
    TabButton1.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    TabButton2.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    TabButton3.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    
    if tab == 1 then
        Page1.Visible = true; TabButton1.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    elseif tab == 2 then
        Page2.Visible = true; TabButton2.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    elseif tab == 3 then
        Page3.Visible = true; TabButton3.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    end
end

TabButton1.MouseButton1Click:Connect(function() switchTab(1) end)
TabButton2.MouseButton1Click:Connect(function() switchTab(2) end)
TabButton3.MouseButton1Click:Connect(function() switchTab(3) end)

-- ESP
local espEnabled = false
local espObjects = {}
local espShowName = false
local espTransparency = 0.5

local function createESP(character, color)
    if character and character:FindFirstChild("HumanoidRootPart") then
        if espObjects[character] then espObjects[character]:Destroy() end
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = color
        highlight.FillTransparency = espTransparency
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        if espShowName and character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = character.Head
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = billboard
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = character.Name
            textLabel.TextColor3 = color
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 14
        end
        espObjects[character] = highlight
    end
end

local function updateESP()
    if not espEnabled then return end
    pcall(function() if workspace.StreamingEnabled then workspace.StreamingEnabled = false end end)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            local color = (p == player) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            createESP(p.Character, color)
        end
    end
end

local function clearESP()
    for _, v in pairs(espObjects) do if v then v:Destroy() end end
    espObjects = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local bb = p.Character.Head:FindFirstChildWhichIsA("BillboardGui")
            if bb then bb:Destroy() end
        end
    end
end

-- AIMBOT
local aimbotEnabled = false
local aimbotSmoothness = 0.2
local aimbotFOV = 150
local aimbotPart = "Head"

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local camera = workspace.CurrentCamera
    local centerX, centerY = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local targetPart = p.Character:FindFirstChild(aimbotPart)
            local humanoid = p.Character:FindFirstChild("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = math.sqrt((screenPoint.X - centerX)^2 + (screenPoint.Y - centerY)^2)
                    if distance < aimbotFOV and distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = p
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
        local target = getClosestTarget()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(aimbotPart)
            if targetPart then
                local currentCFrame = workspace.CurrentCamera.CFrame
                local desiredCFrame = CFrame.new(currentCFrame.Position, targetPart.Position)
                workspace.CurrentCamera.CFrame = currentCFrame:Lerp(desiredCFrame, aimbotSmoothness)
            end
        end
    end
end)

-- GOD MODE
local godModeEnabled = false
local godModeConnection
local function startGodMode()
    godModeConnection = RunService.Heartbeat:Connect(function()
        if not godModeEnabled then return end
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then humanoid.Health = humanoid.MaxHealth end
        end
    end)
end
local function stopGodMode()
    if godModeConnection then godModeConnection:Disconnect() end
end

-- SPEED HACK
local speedEnabled = false
local currentSpeed = 50
local defaultSpeed = 16
local speedConnection
local function startSpeedHack()
    speedConnection = RunService.Heartbeat:Connect(function()
        if not speedEnabled then return end
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then humanoid.WalkSpeed = currentSpeed end
        end
    end)
end
local function stopSpeedHack()
    if speedConnection then speedConnection:Disconnect() end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.WalkSpeed = defaultSpeed end
    end
end

-- INFINITE AMMO
local infiniteAmmoEnabled = false
local ammoConnection
local function startInfiniteAmmo()
    ammoConnection = RunService.Heartbeat:Connect(function()
        if not infiniteAmmoEnabled then return end
        local character = player.Character
        if not character then return end
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in pairs(tool:GetDescendants()) do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        if string.find(string.lower(v.Name), "ammo") or string.find(string.lower(v.Name), "clip") or string.find(string.lower(v.Name), "mag") then
                            v.Value = 9999 
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- КНОПКИ (Страница 1: Функции)
-- ==========================================
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = Page1
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
SpeedButton.Text = "Бесконечный прыжок"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.Gotham
SpeedButton.TextSize = 14
local sc1 = Instance.new("UICorner"); sc1.CornerRadius = UDim.new(0, 5); sc1.Parent = SpeedButton

local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = Page1
GodModeButton.Size = UDim2.new(0.9, 0, 0, 35)
GodModeButton.Position = UDim2.new(0.05, 0, 0, 45)
GodModeButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
GodModeButton.Text = "Включить Бессмертие"
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeButton.Font = Enum.Font.Gotham
GodModeButton.TextSize = 14
local gmc1 = Instance.new("UICorner"); gmc1.CornerRadius = UDim.new(0, 5); gmc1.Parent = GodModeButton

local AmmoButton = Instance.new("TextButton")
AmmoButton.Parent = Page1
AmmoButton.Size = UDim2.new(0.9, 0, 0, 35)
AmmoButton.Position = UDim2.new(0.05, 0, 0, 90)
AmmoButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
AmmoButton.Text = "Бесконечные патроны"
AmmoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AmmoButton.Font = Enum.Font.Gotham
AmmoButton.TextSize = 14
local sc3 = Instance.new("UICorner"); sc3.CornerRadius = UDim.new(0, 5); sc3.Parent = AmmoButton

local SpeedHackButton = Instance.new("TextButton")
SpeedHackButton.Parent = Page1
SpeedHackButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedHackButton.Position = UDim2.new(0.05, 0, 0, 135)
SpeedHackButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
SpeedHackButton.Text = "Включить Speed Hack"
SpeedHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackButton.Font = Enum.Font.Gotham
SpeedHackButton.TextSize = 14
local sc4 = Instance.new("UICorner"); sc4.CornerRadius = UDim.new(0, 5); sc4.Parent = SpeedHackButton

local SpeedSettingButton = Instance.new("TextButton")
SpeedSettingButton.Parent = Page1
SpeedSettingButton.Size = UDim2.new(0.9, 0, 0, 30)
SpeedSettingButton.Position = UDim2.new(0.05, 0, 0, 180)
SpeedSettingButton.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
SpeedSettingButton.Text = "Скорость: 50"
SpeedSettingButton.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedSettingButton.Font = Enum.Font.Gotham
SpeedSettingButton.TextSize = 13
local sc5 = Instance.new("UICorner"); sc5.CornerRadius = UDim.new(0, 5); sc5.Parent = SpeedSettingButton

-- ==========================================
-- КНОПКИ (Страница 2: Аим и ESP)
-- ==========================================
local AimbotButton = Instance.new("TextButton")
AimbotButton.Parent = Page2
AimbotButton.Size = UDim2.new(0.9, 0, 0, 35)
AimbotButton.Position = UDim2.new(0.05, 0, 0, 0)
AimbotButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
AimbotButton.Text = "Включить Aimbot (ПКМ/Выстрел)"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.Font = Enum.Font.Gotham
AimbotButton.TextSize = 14
local ac1 = Instance.new("UICorner"); ac1.CornerRadius = UDim.new(0, 5); ac1.Parent = AimbotButton

local EspButton = Instance.new("TextButton")
EspButton.Parent = Page2
EspButton.Size = UDim2.new(0.9, 0, 0, 35)
EspButton.Position = UDim2.new(0.05, 0, 0, 45)
EspButton.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
EspButton.Text = "Включить ESP"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.Gotham
EspButton.TextSize = 14
local sc2 = Instance.new("UICorner"); sc2.CornerRadius = UDim.new(0, 5); sc2.Parent = EspButton

-- ==========================================
-- КНОПКИ (Страница 3: Настройки)
-- ==========================================
local FOVToggle = Instance.new("TextButton")
FOVToggle.Parent = Page3
FOVToggle.Size = UDim2.new(0.9, 0, 0, 35)
FOVToggle.Position = UDim2.new(0.05, 0, 0, 0)
FOVToggle.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
FOVToggle.Text = "Радиус Аима (FOV): 150"
FOVToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVToggle.Font = Enum.Font.Gotham
FOVToggle.TextSize = 14
local fovC = Instance.new("UICorner"); fovC.CornerRadius = UDim.new(0, 5); fovC.Parent = FOVToggle

local SmoothToggle = Instance.new("TextButton")
SmoothToggle.Parent = Page3
SmoothToggle.Size = UDim2.new(0.9, 0, 0, 35)
SmoothToggle.Position = UDim2.new(0.05, 0, 0, 45)
SmoothToggle.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
SmoothToggle.Text = "Плавность Аима: 0.2"
SmoothToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
SmoothToggle.Font = Enum.Font.Gotham
SmoothToggle.TextSize = 14
local smC = Instance.new("UICorner"); smC.CornerRadius = UDim.new(0, 5); smC.Parent = SmoothToggle

local PartToggle = Instance.new("TextButton")
PartToggle.Parent = Page3
PartToggle.Size = UDim2.new(0.9, 0, 0, 35)
PartToggle.Position = UDim2.new(0.05, 0, 0, 90)
PartToggle.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
PartToggle.Text = "Целиться в: ГОЛОВУ"
PartToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
PartToggle.Font = Enum.Font.Gotham
PartToggle.TextSize = 14
local ptC = Instance.new("UICorner"); ptC.CornerRadius = UDim.new(0, 5); ptC.Parent = PartToggle

local NameToggle = Instance.new("TextButton")
NameToggle.Parent = Page3
NameToggle.Size = UDim2.new(0.9, 0, 0, 35)
NameToggle.Position = UDim2.new(0.05, 0, 0, 135)
NameToggle.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
NameToggle.Text = "Показывать ники: ВЫКЛ"
NameToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NameToggle.Font = Enum.Font.Gotham
NameToggle.TextSize = 14
local nc1 = Instance.new("UICorner"); nc1.CornerRadius = UDim.new(0, 5); nc1.Parent = NameToggle

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
    SpeedButton.Text = infiniteJumpEnabled and "Выключить прыжок" or "Бесконечный прыжок"
    SpeedButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(70, 40, 100)
end)

GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    GodModeButton.Text = godModeEnabled and "Выключить Бессмертие" or "Включить Бессмертие"
    GodModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(70, 40, 100)
    if godModeEnabled then startGodMode() else stopGodMode() en

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
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
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

-- Кнопки вкладок (Вкладка 1: Меню, Вкладка 2: Настройки ESP)
local TabButton1 = Instance.new("TextButton")
TabButton1.Parent = MainFrame
TabButton1.Size = UDim2.new(0.45, 0, 0, 25)
TabButton1.Position = UDim2.new(0.03, 0, 0.1, 0)
TabButton1.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TabButton1.Text = "Функции"
TabButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton1.Font = Enum.Font.GothamBold
TabButton1.TextSize = 12
TabButton1.BorderSizePixel = 0
local tab1Corner = Instance.new("UICorner"); tab1Corner.CornerRadius = UDim.new(0, 5); tab1Corner.Parent = TabButton1

local TabButton2 = Instance.new("TextButton")
TabButton2.Parent = MainFrame
TabButton2.Size = UDim2.new(0.45, 0, 0, 25)
TabButton2.Position = UDim2.new(0.52, 0, 0.1, 0)
TabButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TabButton2.Text = "Настройки ESP"
TabButton2.TextColor3 = Color3.fromRGB(200, 200, 200)
TabButton2.Font = Enum.Font.GothamBold
TabButton2.TextSize = 12
TabButton2.BorderSizePixel = 0
local tab2Corner = Instance.new("UICorner"); tab2Corner.CornerRadius = UDim.new(0, 5); tab2Corner.Parent = TabButton2

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

-- СКРОЛЛ-ФРЕЙМЫ (Для листания)
local Page1 = Instance.new("ScrollingFrame")
Page1.Parent = MainFrame
Page1.Size = UDim2.new(0.95, 0, 0.8, 0)
Page1.Position = UDim2.new(0.025, 0, 0.2, 0)
Page1.BackgroundTransparency = 1
Page1.BorderSizePixel = 0
Page1.ScrollBarThickness = 4
Page1.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
Page1.Visible = true

local Page2 = Instance.new("ScrollingFrame")
Page2.Parent = MainFrame
Page2.Size = UDim2.new(0.95, 0, 0.8, 0)
Page2.Position = UDim2.new(0.025, 0, 0.2, 0)
Page2.BackgroundTransparency = 1
Page2.BorderSizePixel = 0
Page2.ScrollBarThickness = 4
Page2.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
Page2.Visible = false

-- Переключение вкладок
TabButton1.MouseButton1Click:Connect(function()
    Page1.Visible = true; Page2.Visible = false
    TabButton1.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TabButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
end)
TabButton2.MouseButton1Click:Connect(function()
    Page1.Visible = false; Page2.Visible = true
    TabButton1.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabButton2.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

-- ==========================================
-- НАСТРОЙКИ ESP
-- ==========================================
local espEnabled = false
local espObjects = {}
local espShowName = false
local espTransparency = 0.5 -- Яркость (0 = сплошной, 1 = прозрачный)

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
        
        if espShowName then
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
    -- Удаляем старые ники, если они остались
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local bb = p.Character.Head:FindFirstChildWhichIsA("BillboardGui")
            if bb then bb:Destroy() end
        end
    end
end

-- ==========================================
-- SPEED HACK
-- ==========================================
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

-- ==========================================
-- INFINITE AMMO
-- ==========================================
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
-- СОЗДАНИЕ КНОПОК (Страница 1)
-- ==========================================
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = Page1
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
SpeedButton.Text = "Бесконечный прыжок"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.Gotham
SpeedButton.TextSize = 14
local sc1 = Instance.new("UICorner"); sc1.CornerRadius = UDim.new(0, 5); sc1.Parent = SpeedButton

local EspButton = Instance.new("TextButton")
EspButton.Parent = Page1
EspButton.Size = UDim2.new(0.9, 0, 0, 35)
EspButton.Position = UDim2.new(0.05, 0, 0, 45)
EspButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
EspButton.Text = "Включить ESP"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.Gotham
EspButton.TextSize = 14
local sc2 = Instance.new("UICorner"); sc2.CornerRadius = UDim.new(0, 5); sc2.Parent = EspButton

local AmmoButton = Instance.new("TextButton")
AmmoButton.Parent = Page1
AmmoButton.Size = UDim2.new(0.9, 0, 0, 35)
AmmoButton.Position = UDim2.new(0.05, 0, 0, 90)
AmmoButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
AmmoButton.Text = "Бесконечные патроны"
AmmoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AmmoButton.Font = Enum.Font.Gotham
AmmoButton.TextSize = 14
local sc3 = Instance.new("UICorner"); sc3.CornerRadius = UDim.new(0, 5); sc3.Parent = AmmoButton

local SpeedHackButton = Instance.new("TextButton")
SpeedHackButton.Parent = Page1
SpeedHackButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedHackButton.Position = UDim2.new(0.05, 0, 0, 135)
SpeedHackButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
SpeedHackButton.Text = "Включить Speed Hack"
SpeedHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackButton.Font = Enum.Font.Gotham
SpeedHackButton.TextSize = 14
local sc4 = Instance.new("UICorner"); sc4.CornerRadius = UDim.new(0, 5); sc4.Parent = SpeedHackButton

local SpeedSettingButton = Instance.new("TextButton")
SpeedSettingButton.Parent = Page1
SpeedSettingButton.Size = UDim2.new(0.9, 0, 0, 30)
SpeedSettingButton.Position = UDim2.new(0.05, 0, 0, 180)
SpeedSettingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedSettingButton.Text = "Скорость: 50"
SpeedSettingButton.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedSettingButton.Font = Enum.Font.Gotham
SpeedSettingButton.TextSize = 13
local sc5 = Instance.new("UICorner"); sc5.CornerRadius = UDim.new(0, 5); sc5.Parent = SpeedSettingButton

-- ==========================================
-- СОЗДАНИЕ НАСТРОЕК (Страница 2 - ESP)
-- ==========================================
local NameToggle = Instance.new("TextButton")
NameToggle.Parent = Page2
NameToggle.Size = UDim2.new(0.9, 0, 0, 35)
NameToggle.Position = UDim2.new(0.05, 0, 0, 0)
NameToggle.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
NameToggle.Text = "Показывать ники: ВЫКЛ"
NameToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NameToggle.Font = Enum.Font.Gotham
NameToggle.TextSize = 14
local nc1 = Instance.new("UICorner"); nc1.CornerRadius = UDim.new(0, 5); nc1.Parent = NameToggle

local BrightnessToggle = Instance.new("TextButton")
BrightnessToggle.Parent = Page2
BrightnessToggle.Size = UDim2.new(0.9, 0, 0, 35)
BrightnessToggle.Position = UDim2.new(0.05, 0, 0, 45)
BrightnessToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
BrightnessToggle.Text = "Яркость ESP: 50%"
BrightnessToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
BrightnessToggle.Font = Enum.Font.Gotham
BrightnessToggle.TextSize = 14
local nc2 = Instance.new("UICorner"); nc2.CornerRadius = UDim.new(0, 5); nc2.Parent = BrightnessToggle

local ColorToggle = Instance.new("TextButton")
ColorToggle.Parent = Page2
ColorToggle.Size = UDim2.new(0.9, 0, 0, 35)
ColorToggle.Position = UDim2.new(0.05, 0, 0, 90)
ColorToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ColorToggle.Text = "Цвет врагов: КРАСНЫЙ"
ColorToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
ColorToggle.Font = Enum.Font.Gotham
ColorToggle.TextSize = 14
local nc3 = Instance.new("UICorner"); nc3.CornerRadius = UDim.new(0, 5); nc3.Parent = ColorToggle

-- ==========================================
-- ОБРАБОТЧИКИ НАЖАТИЙ
-- ==========================================
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
    SpeedButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
end)

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspButton.Text = espEnabled and "Выключить ESP" or "Включить ESP"
    EspButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
    if espEnabled then updateESP() else clearESP() end
end)

AmmoButton.MouseButton1Click:Connect(function()
    infiniteAmmoEnabled = not infiniteAmmoEnabled
    AmmoButton.Text = infiniteAmmoEnabled and "Выключить патроны" or "Бесконечные патроны"
    AmmoButton.BackgroundColor3 = infiniteAmmoEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
    if infiniteAmmoEnabled then startInfiniteAmmo() else if ammoConnection then ammoConnection:Disconnect() end end
end)

SpeedHackButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    SpeedHackButton.Text = speedEnabled and "Выключить Speed Hack" or "Включить Speed Hack"
    SpeedHackButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
    if speedEnabled then startSpeedHack() else stopSpeedHack() end
end)

local speedValues = {20, 30, 50, 75, 100, 150, 200}
local speedIndex = 3
SpeedSettingButton.MouseButton1Click:Connect(function()
    speedIndex = speedIndex + 1
    if speedIndex > #speedValues then speedIndex = 1 end
    currentSpeed = speedValues[speedIndex]
    SpeedSettingButton.Text = "Скорость: " .. tostring(currentSpeed)
end)

-- Обработчики для Настроек ESP (Вкладка 2)
NameToggle.MouseButton1Click:Connect(function()
    espShowName = not espShowName
    NameToggle.Text = espShowName and "Показывать ники: ВКЛ" or "Показывать ники: ВЫКЛ"
    NameToggle.BackgroundColor3 = espShowName and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 180)
    if espEnabled then clearESP(); updateESP() end
end)

local transparencies = {0.5, 0.2, 0.7, 0.9} -- 0.2 = яркий, 0.9 = почти прозрачный
local brightnessIndex = 1
BrightnessToggle.MouseButton1Click:Connect(function()
    brightnessIndex = brightnessIndex + 1
    if brightnessIndex > #transparencies then brightnessIndex = 1 end
    espTransparency = transparencies[brightnessIndex]
    BrightnessToggle.Text = "Яркость ESP: " .. tostring(math.floor((1 - espTransparency) * 100)) .. "%"
    if espEnabled then clearESP(); updateESP() end
end)

local colorModes = {"КРАСНЫЙ", "СИНИЙ", "ЗЕЛЕНЫЙ", "ЖЕЛТЫЙ", "БЕЛЫЙ"}
local colorValues = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 100, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255)}
local colorIndex = 1
ColorToggle.MouseButton1Click:Connect(function()
    colorIndex = colorIndex + 1
    if colorIndex > #colorModes then colorIndex = 1 end
    ColorToggle.Text = "Цвет врагов: " .. colorModes[colorIndex]
    if espEnabled then clearESP(); updateESP() end
end)

-- ==========================================
-- АНИМАЦИИ И АВТОЗАПУСК
-- ==========================================
local TweenService = game:GetService("TweenService")
local menuOpen = false

local function OpenMenu()
    menuOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 420)})
    tween:Play()
end

local function CloseMenu()
    menuOpen = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    if menuOpen then CloseMenu() else OpenMenu() end
end)
CloseButton.MouseButton1Click:Connect(CloseMenu)

OpenMenu()

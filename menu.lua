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
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Для анимации
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175) -- Чуть выше центра
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

-- ЛОГИКА ПЕРЕТАСКИВАНИЯ
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local dragging = false
local dragInput, dragStart, startPos

local function setupDrag(object)
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if object:IsA("TextButton") or object:IsA("TextBox") then return end
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
setupDrag(MainFrame)

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
    pcall(function() if workspace.StreamingEnabled then workspace.StreamingEnabled = false end end)
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
    pcall(function() if workspace.StreamingEnabled then workspace.StreamingEnabled = true end end)
end

-- NOCLIP (Без проваливания через пол)
local noclipEnabled = false
local noclipConnection

local function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local character = player.Character
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    -- Сохраняем коллизию у пола (чтобы не падать), отключаем у всего остального
                    if v.Name ~= "HumanoidRootPart" then
                        -- Проверка: если деталь ниже персонажа (пол), оставляем коллизию
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            -- Если эта деталь (пол) ниже нашего корпуса, не отключаем ей коллизию
                            if v.Position.Y < rootPart.Position.Y - 2 then
                                v.CanCollide = true
                            else
                                v.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    local character = player.Character
    if character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- КНОПКИ
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = MainFrame
SpeedButton.Size = UDim2.new(0.9, 0, 0, 40)
SpeedButton.Position = UDim2.new(0.05, 0, 0.2, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
SpeedButton.Text = "Включить бесконечный прыжок"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.Gotham
SpeedButton.TextSize = 15
local speedCorner = Instance.new("UICorner"); speedCorner.CornerRadius = UDim.new(0, 5); speedCorner.Parent = SpeedButton

local EspButton = Instance.new("TextButton")
EspButton.Parent = MainFrame
EspButton.Size = UDim2.new(0.9, 0, 0, 40)
EspButton.Position = UDim2.new(0.05, 0, 0.4, 0)
EspButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
EspButton.Text = "Включить ESP (Подсветку)"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.Gotham
EspButton.TextSize = 15
local espCorner = Instance.new("UICorner"); espCorner.CornerRadius = UDim.new(0, 5); espCorner.Parent = EspButton

local NoclipButton = Instance.new("TextButton")
NoclipButton.Parent = MainFrame
NoclipButton.Size = UDim2.new(0.9, 0, 0, 40)
NoclipButton.Position = UDim2.new(0.05, 0, 0.6, 0)
NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
NoclipButton.Text = "Включить Noclip (Стены)"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.Gotham
NoclipButton.TextSize = 15
local noclipCorner = Instance.new("UICorner"); noclipCorner.CornerRadius = UDim.new(0, 5); noclipCorner.Parent = NoclipButton

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

NoclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipButton.Text = "Выключить Noclip (Стены)"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        startNoclip()
    else
        NoclipButton.Text = "Включить Noclip (Стены)"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        stopNoclip()
    end
end)

-- АНИМАЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ
local TweenService = game:GetService("TweenService")
local menuOpen = false

local function OpenMenu()
    menuOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 350)}) -- Высота 350 под 3 кнопки
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

-- АВТОЗАПУСК
OpenMenu()

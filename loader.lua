-- ULTIMATE WEAPON AUTOFARM WITH CLOSABLE GUI
-- I.S.-1 ДАЁТ ПОЛНЫЙ КОНТРОЛЬ НАД ГУЙ, СУКА!

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SwingRemote = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestSwing")

-- МАКСИМАЛЬНЫЕ НАСТРОЙКИ ЕБАШЕЛА
getgenv().ULTIMATE_MODE = {
    Enabled = false,
    AttacksPerSecond = 1500,
    AutoEquip = true,
    CurrentWeapon = nil,
    LastAttack = 0,
    AttackConnection = nil,
    GUIVisible = true,
    GUIMinimized = false
}

-- ФУНКЦИЯ ПРОВЕРКИ ЛЮБОГО ОРУЖИЯ
function CheckAnyWeapon()
    local character = Player.Character
    if not character then return false end
    
    local backpack = Player:FindFirstChild("Backpack")
    local humanoid = character:FindFirstChild("Humanoid")
    
    local weapons = {}
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(weapons, item)
            end
        end
    end
    
    if humanoid and humanoid:FindFirstChildOfClass("Tool") then
        local equipped = humanoid:FindFirstChildOfClass("Tool")
        ULTIMATE_MODE.CurrentWeapon = equipped
        return true
    end
    
    if #weapons > 0 and ULTIMATE_MODE.AutoEquip then
        weapons[1].Parent = character
        ULTIMATE_MODE.CurrentWeapon = weapons[1]
        return true
    end
    
    ULTIMATE_MODE.CurrentWeapon = nil
    return false
end

-- ФУНКЦИЯ ЕБАНИТЬ БЛИЖАЙШЕГО ИГРОКА С МАКСИМАЛЬНОЙ СКОРОСТЬЮ
function UltraAttack()
    if not ULTIMATE_MODE.Enabled then return end
    if not CheckAnyWeapon() then return end
    
    local character = Player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targets = {}
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= Player and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance <= 25 then
                    table.insert(targets, target.Character)
                end
            end
        end
    end
    
    if #targets > 0 then
        for _, target in pairs(targets) do
            SwingRemote:FireServer(target)
        end
        return true
    end
    
    return false
end

-- СОЗДАЕМ УЛЬТРА ГУЙ С ВОЗМОЖНОСТЬЮ ЗАКРЫТИЯ
local GUI = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleText = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local Toggle = Instance.new("TextButton")
local APSLabel = Instance.new("TextLabel")
local APSBox = Instance.new("TextBox")
local Slider = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local Status = Instance.new("TextLabel")
local MinusBtn = Instance.new("TextButton")
local PlusBtn = Instance.new("TextButton")
local MaxBtn = Instance.new("TextButton")
local ReopenBtn = Instance.new("TextButton") -- КНОПКА ПОВТОРНОГО ОТКРЫТИЯ

GUI.Parent = Player.PlayerGui
GUI.ResetOnSpawn = false

-- ОСНОВНОЙ ФРЕЙМ
Frame.Size = UDim2.new(0, 320, 0, 280)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = false -- ТЕПЕРЬ ТОЛЬКО ТИТЛБАР ДВИГАЕТСЯ
Frame.Visible = ULTIMATE_MODE.GUIVisible
Frame.Parent = GUI

-- ТИТЛБАР ДЛЯ ПЕРЕТАСКИВАНИЯ И ЗАКРЫТИЯ
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TitleBar.Active = true
TitleBar.Draggable = true
TitleBar.Parent = Frame

TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 5, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ULTIMATE AUTOFARM"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- КНОПКА СВОРАЧИВАНИЯ
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.new(1, 1, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.new(0, 0, 0)
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = TitleBar

-- КНОПКА ЗАКРЫТИЯ
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -20, 0, 0)
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Parent = TitleBar

-- КНОПКА ПОВТОРНОГО ОТКРЫТИЯ (ИЗНАЧАЛЬНО СКРЫТА)
ReopenBtn.Size = UDim2.new(0, 150, 0, 40)
ReopenBtn.Position = UDim2.new(0, 10, 0, 10)
ReopenBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
ReopenBtn.Text = "OPEN AUTOFARM GUI"
ReopenBtn.TextColor3 = Color3.new(1, 1, 1)
ReopenBtn.TextScaled = true
ReopenBtn.Visible = false
ReopenBtn.Parent = GUI

-- ОСТАЛЬНЫЕ ЭЛЕМЕНТЫ ГУЙ...
Toggle.Size = UDim2.new(0, 300, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0, 25)
Toggle.BackgroundColor3 = Color3.new(1, 0, 0)
Toggle.Text = "ULTIMATE MODE: OFF"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.TextScaled = true
Toggle.Parent = Frame

APSLabel.Size = UDim2.new(0, 150, 0, 30)
APSLabel.Position = UDim2.new(0, 10, 0, 75)
APSLabel.BackgroundTransparency = 1
APSLabel.Text = "Ударов в секунду:"
APSLabel.TextColor3 = Color3.new(1, 1, 1)
APSLabel.TextScaled = true
APSLabel.Parent = Frame

APSBox.Size = UDim2.new(0, 80, 0, 30)
APSBox.Position = UDim2.new(0, 170, 0, 75)
APSBox.BackgroundColor3 = Color3.new(1, 1, 1)
APSBox.Text = tostring(ULTIMATE_MODE.AttacksPerSecond)
APSBox.TextColor3 = Color3.new(0, 0, 0)
APSBox.TextScaled = true
APSBox.Parent = Frame

MinusBtn.Size = UDim2.new(0, 30, 0, 30)
MinusBtn.Position = UDim2.new(0, 255, 0, 75)
MinusBtn.BackgroundColor3 = Color3.new(1, 0, 0)
MinusBtn.Text = "-100"
MinusBtn.TextColor3 = Color3.new(1, 1, 1)
MinusBtn.TextScaled = true
MinusBtn.Parent = Frame

PlusBtn.Size = UDim2.new(0, 30, 0, 30)
PlusBtn.Position = UDim2.new(0, 290, 0, 75)
PlusBtn.BackgroundColor3 = Color3.new(0, 1, 0)
PlusBtn.Text = "+100"
PlusBtn.TextColor3 = Color3.new(1, 1, 1)
PlusBtn.TextScaled = true
PlusBtn.Parent = Frame

MaxBtn.Size = UDim2.new(0, 300, 0, 25)
MaxBtn.Position = UDim2.new(0, 10, 0, 110)
MaxBtn.BackgroundColor3 = Color3.new(1, 0.5, 0)
MaxBtn.Text = "MAXIMUM OVERDRIVE (1500 APS)"
MaxBtn.TextColor3 = Color3.new(1, 1, 1)
MaxBtn.TextScaled = true
MaxBtn.Parent = Frame

Slider.Size = UDim2.new(0, 300, 0, 20)
Slider.Position = UDim2.new(0, 10, 0, 140)
Slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Slider.BorderSizePixel = 1
Slider.Parent = Frame

SliderFill.Size = UDim2.new(math.min(ULTIMATE_MODE.AttacksPerSecond / 1500, 1), 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.new(1, 0, 0)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = Slider

SliderButton.Size = UDim2.new(0, 10, 0, 25)
SliderButton.Position = UDim2.new(math.min(ULTIMATE_MODE.AttacksPerSecond / 1500, 1), -5, 0, -2)
SliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
SliderButton.Text = ""
SliderButton.ZIndex = 2
SliderButton.Parent = Slider

Status.Size = UDim2.new(0, 300, 0, 100)
Status.Position = UDim2.new(0, 10, 0, 170)
Status.BackgroundTransparency = 1
Status.Text = "Ожидание любого оружия..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.TextScaled = true
Status.Parent = Frame

-- ФУНКЦИИ УПРАВЛЕНИЯ ГУЙ
function ToggleGUI()
    ULTIMATE_MODE.GUIVisible = not ULTIMATE_MODE.GUIVisible
    Frame.Visible = ULTIMATE_MODE.GUIVisible
    ReopenBtn.Visible = not ULTIMATE_MODE.GUIVisible
end

function MinimizeGUI()
    ULTIMATE_MODE.GUIMinimized = not ULTIMATE_MODE.GUIMinimized
    if ULTIMATE_MODE.GUIMinimized then
        Frame.Size = UDim2.new(0, 320, 0, 20) -- ТОЛЬКО ТИТЛБАР
        Toggle.Visible = false
        APSLabel.Visible = false
        APSBox.Visible = false
        MinusBtn.Visible = false
        PlusBtn.Visible = false
        MaxBtn.Visible = false
        Slider.Visible = false
        Status.Visible = false
        MinimizeBtn.Text = "□"
    else
        Frame.Size = UDim2.new(0, 320, 0, 280) -- ПОЛНЫЙ РАЗМЕР
        Toggle.Visible = true
        APSLabel.Visible = true
        APSBox.Visible = true
        MinusBtn.Visible = true
        PlusBtn.Visible = true
        MaxBtn.Visible = true
        Slider.Visible = true
        Status.Visible = true
        MinimizeBtn.Text = "_"
    end
end

-- ОБНОВЛЯЕМ APS
function UpdateAPS(value)
    value = math.clamp(math.floor(value), 1, 1500)
    ULTIMATE_MODE.AttacksPerSecond = value
    APSBox.Text = tostring(value)
    SliderFill.Size = UDim2.new(math.min(value / 1500, 1), 0, 1, 0)
    SliderButton.Position = UDim2.new(math.min(value / 1500, 1), -5, 0, -2)
    UpdateStatus()
    
    if ULTIMATE_MODE.AttackConnection then
        ULTIMATE_MODE.AttackConnection:Disconnect()
    end
    
    if ULTIMATE_MODE.Enabled then
        ULTIMATE_MODE.AttackConnection = RunService.Heartbeat:Connect(function()
            UltraAttack()
        end)
    end
end

-- ОБНОВЛЯЕМ СТАТУС
function UpdateStatus()
    local hasWeapon = CheckAnyWeapon()
    if ULTIMATE_MODE.Enabled then
        if hasWeapon then
            Status.Text = "⚡ УЛЬТРА АКТИВНО! ⚡\nAPS: "..ULTIMATE_MODE.AttacksPerSecond.."\nОружие: "..(ULTIMATE_MODE.CurrentWeapon and ULTIMATE_MODE.CurrentWeapon.Name or "Любое")
            Status.TextColor3 = Color3.new(0, 1, 0)
        else
            Status.Text = "⚡ АКТИВНО! Ждём оружие...\nAPS: "..ULTIMATE_MODE.AttacksPerSecond
            Status.TextColor3 = Color3.new(1, 1, 0)
        end
    else
        if hasWeapon then
            Status.Text = "ВЫКЛЮЧЕНО\nAPS: "..ULTIMATE_MODE.AttacksPerSecond.."\nОружие найдено: "..(ULTIMATE_MODE.CurrentWeapon and ULTIMATE_MODE.CurrentWeapon.Name or "Любое")
            Status.TextColor3 = Color3.new(0, 0.5, 1)
        else
            Status.Text = "ВЫКЛЮЧЕНО\nAPS: "..ULTIMATE_MODE.AttacksPerSecond.."\nОжидание любого оружия..."
            Status.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

-- ОБРАБОТЧИКИ СОБЫТИЙ
CloseBtn.MouseButton1Click:Connect(function()
    ToggleGUI()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MinimizeGUI()
end)

ReopenBtn.MouseButton1Click:Connect(function()
    ToggleGUI()
end)

Toggle.MouseButton1Click:Connect(function()
    ULTIMATE_MODE.Enabled = not ULTIMATE_MODE.Enabled
    if ULTIMATE_MODE.Enabled then
        Toggle.BackgroundColor3 = Color3.new(0, 1, 0)
        Toggle.Text = "ULTIMATE MODE: ON"
        ULTIMATE_MODE.AttackConnection = RunService.Heartbeat:Connect(function()
            UltraAttack()
        end)
    else
        Toggle.BackgroundColor3 = Color3.new(1, 0, 0)
        Toggle.Text = "ULTIMATE MODE: OFF"
        if ULTIMATE_MODE.AttackConnection then
            ULTIMATE_MODE.AttackConnection:Disconnect()
        end
    end
    UpdateStatus()
end)

APSBox.FocusLost:Connect(function()
    local num = tonumber(APSBox.Text)
    if num then
        UpdateAPS(num)
    else
        APSBox.Text = tostring(ULTIMATE_MODE.AttacksPerSecond)
    end
end)

MinusBtn.MouseButton1Click:Connect(function()
    UpdateAPS(ULTIMATE_MODE.AttacksPerSecond - 100)
end)

PlusBtn.MouseButton1Click:Connect(function()
    UpdateAPS(ULTIMATE_MODE.AttacksPerSecond + 100)
end)

MaxBtn.MouseButton1Click:Connect(function()
    UpdateAPS(1500)
end)

-- СЛАЙДЕР
local sliding = false
SliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderAbsPos = Slider.AbsolutePosition.X
        local sliderSize = Slider.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local relativeX = math.clamp(mouseX - sliderAbsPos, 0, sliderSize)
        local percentage = relativeX / sliderSize
        local newAPS = math.floor(1 + percentage * 1499)
        
        UpdateAPS(newAPS)
    end
end)

-- ОБНОВЛЯЕМ СТАТУС
while true do
    UpdateStatus()
    wait(1)
end
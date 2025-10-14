-- AAI-01 UNIVERSAL TOWER TROLL SCRIPT
-- GitHub: https://raw.githubusercontent.com/ABSOLUTE-01/Roblox-Scripts/main/UniversalTowerTroll.lua

local AAI_UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ABSOLUTE-01/Roblox-Scripts/main/AAI_UILib.lua"))()

-- Основные сервисы
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Глобальные переменные
local FlyConnection
local NoclipConnection
local AntiAfkConnection
local TrollConnection
local SpeedConnection
local TeleportConnection

-- Конфигурация
local Config = {
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    AntiAfk = true,
    TrollMode = false,
    AutoFinish = false,
    SpeedHack = false,
    Invisible = false,
    GodMode = false
}

-- ОСНОВНЫЕ ФУНКЦИИ ТРОЛЛИНГА
local TrollFunctions = {}

-- 1. РЕЖИМ ПОЛЕТА
TrollFunctions.EnableFly = function()
    if FlyConnection then FlyConnection() end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = rootPart

    FlyConnection = function()
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                bodyVelocity.Velocity = rootPart.CFrame.LookVector * Config.FlySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                bodyVelocity.Velocity = -rootPart.CFrame.LookVector * Config.FlySpeed
            elseif input.KeyCode == Enum.KeyCode.A then
                bodyVelocity.Velocity = -rootPart.CFrame.RightVector * Config.FlySpeed
            elseif input.KeyCode == Enum.KeyCode.D then
                bodyVelocity.Velocity = rootPart.CFrame.RightVector * Config.FlySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, Config.FlySpeed, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                bodyVelocity.Velocity = Vector3.new(0, -Config.FlySpeed, 0)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
               input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or
               input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
    
    FlyConnection()
    return function() bodyVelocity:Destroy() end
end

-- 2. NOClip (прохождение сквозь стены)
TrollFunctions.EnableNoclip = function()
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if Config.Noclip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- 3. СУПЕР-СКОРОСТЬ
TrollFunctions.EnableSpeed = function()
    if SpeedConnection then SpeedConnection:Disconnect() end
    
    SpeedConnection = RunService.Heartbeat:Connect(function()
        if Config.SpeedHack and humanoid then
            humanoid.WalkSpeed = Config.WalkSpeed
            humanoid.JumpPower = Config.JumpPower
        end
    end)
end

-- 4. АВТО-ФИНИШ (автоматический проход башни)
TrollFunctions.EnableAutoFinish = function()
    spawn(function()
        while Config.AutoFinish do
            wait(1)
            -- Ищем финишные платформы
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("finish") or obj.Name:lower():find("end") or obj.Name:lower():find("win") then
                    if obj:IsA("Part") then
                        rootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end)
end

-- 5. ТЕЛЕПОРТ К ИГРОКАМ (для троллинга)
TrollFunctions.TeleportToPlayer = function(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- 6. ПУШ ИГРОКОВ (отталкивание других игроков)
TrollFunctions.EnablePlayerPush = function()
    spawn(function()
        while Config.TrollMode do
            wait(0.5)
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local direction = (otherPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Unit
                    otherPlayer.Character.HumanoidRootPart.Velocity = direction * 100
                end
            end
        end
    end)
end

-- 7. НЕВИДИМОСТЬ
TrollFunctions.EnableInvisible = function()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = Config.Invisible and 0.8 or 0
        elseif part:IsA("Decal") then
            part.Transparency = Config.Invisible and 0.8 or 0
        end
    end
end

-- 8. РЕЖИМ БОГА (бессмертие)
TrollFunctions.EnableGodMode = function()
    if humanoid then
        humanoid.MaxHealth = Config.GodMode and math.huge or 100
        if Config.GodMode then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end

-- 9. АНТИ-AFK (авто-движение)
TrollFunctions.EnableAntiAfk = function()
    if AntiAfkConnection then AntiAfkConnection:Disconnect() end
    
    AntiAfkConnection = RunService.Heartbeat:Connect(function()
        if Config.AntiAfk then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- 10. СПАВН ПЛАТФОРМ В ВОЗДУХЕ
TrollFunctions.SpawnAirPlatforms = function()
    local platform = Instance.new("Part")
    platform.Name = "AAI_AirPlatform"
    platform.Size = Vector3.new(20, 1, 20)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.7
    platform.BrickColor = BrickColor.new("Bright red")
    platform.Material = Enum.Material.Neon
    platform.CFrame = rootPart.CFrame - Vector3.new(0, 5, 0)
    platform.Parent = Workspace
    
    -- Авто-удаление через 30 секунд
    delay(30, function() platform:Destroy() end)
end

-- 11. ТЕЛЕПОРТ НА САМЫЙ ВЕРХ
TrollFunctions.TeleportToTop = function()
    local highestY = -math.huge
    local topPart = nil
    
    -- Ищем самую высокую часть в башне
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Position.Y > highestY then
            highestY = obj.Position.Y
            topPart = obj
        end
    end
    
    if topPart then
        rootPart.CFrame = topPart.CFrame + Vector3.new(0, 10, 0)
    end
end

-- 12. АВТО-ПРЫЖКИ
TrollFunctions.EnableAutoJump = function()
    spawn(function()
        while Config.TrollMode do
            wait(0.2)
            if humanoid then
                humanoid.Jump = true
            end
        end
    end)
end

-- СОЗДАНИЕ ИНТЕРФЕЙСА
local MainWindow = AAI_UILib:CreateMainWindow("AAI-01 UNIVERSAL TOWER TROLL")
local TabSystem = AAI_UILib:CreateTabSystem(MainWindow.TabContainer)

-- ВКЛАДКА: ОСНОВНЫЕ ФУНКЦИИ
local MainTab = TabSystem:CreateTab("Основные")

AAI_UILib:CreateButton(MainTab, "🔄 АКТИВИРОВАТЬ ВСЕ ФУНКЦИИ", function()
    Config.Noclip = true
    Config.SpeedHack = true
    Config.GodMode = true
    Config.AntiAfk = true
    
    TrollFunctions.EnableNoclip()
    TrollFunctions.EnableSpeed()
    TrollFunctions.EnableGodMode()
    TrollFunctions.EnableAntiAfk()
    TrollFunctions.EnableFly()
end)

AAI_UILib:CreateButton(MainTab, "✈️ ВКЛЮЧИТЬ ПОЛЕТ", function()
    TrollFunctions.EnableFly()
end)

AAI_UILib:CreateToggle(MainTab, "🚶 NOClip (сквозь стены)", false, function(value)
    Config.Noclip = value
    TrollFunctions.EnableNoclip()
end)

AAI_UILib:CreateToggle(MainTab, "⚡ Режим Бога", false, function(value)
    Config.GodMode = value
    TrollFunctions.EnableGodMode()
end)

AAI_UILib:CreateToggle(MainTab, "👻 Невидимость", false, function(value)
    Config.Invisible = value
    TrollFunctions.EnableInvisible()
end)

-- ВКЛАДКА: ТРОЛЛИНГ
local TrollTab = TabSystem:CreateTab("Троллинг")

AAI_UILib:CreateButton(TrollTab, "🎯 ТЕЛЕПОРТ НА ВЕРХ БАШНИ", function()
    TrollFunctions.TeleportToTop()
end)

AAI_UILib:CreateButton(TrollTab, "🔄 АКТИВИРОВАТЬ ТРОЛЛЬ РЕЖИМ", function()
    Config.TrollMode = true
    TrollFunctions.EnablePlayerPush()
    TrollFunctions.EnableAutoJump()
end)

AAI_UILib:CreateButton(TrollTab, "🏗️ СОЗДАТЬ ПЛАТФОРМУ В ВОЗДУХЕ", function()
    TrollFunctions.SpawnAirPlatforms()
end)

AAI_UILib:CreateToggle(TrollTab, "🤖 Авто-Финиш", false, function(value)
    Config.AutoFinish = value
    if value then
        TrollFunctions.EnableAutoFinish()
    end
end)

-- ВКЛАДКА: СКОРОСТЬ И ДВИЖЕНИЕ
local SpeedTab = TabSystem:CreateTab("Скорость")

AAI_UILib:CreateSlider(SpeedTab, "Скорость полета", 1, 100, 50, function(value)
    Config.FlySpeed = value
end)

AAI_UILib:CreateSlider(SpeedTab, "Скорость ходьбы", 16, 200, 16, function(value)
    Config.WalkSpeed = value
    TrollFunctions.EnableSpeed()
end)

AAI_UILib:CreateSlider(SpeedTab, "Сила прыжка", 50, 500, 50, function(value)
    Config.JumpPower = value
    TrollFunctions.EnableSpeed()
end)

AAI_UILib:CreateToggle(SpeedTab, "⚡ Супер-скорость", false, function(value)
    Config.SpeedHack = value
    TrollFunctions.EnableSpeed()
end)

-- ВКЛАДКА: ИГРОКИ
local PlayersTab = TabSystem:CreateTab("Игроки")

-- Авто-обновление списка игроков
spawn(function()
    while true do
        wait(5)
        for _, child in pairs(PlayersTab:GetChildren()) do
            if child:IsA("TextButton") and child.Name ~= "Button" then
                child:Destroy()
            end
        end
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                AAI_UILib:CreateButton(PlayersTab, "👤 " .. otherPlayer.Name, function()
                    TrollFunctions.TeleportToPlayer(otherPlayer.Name)
                end)
            end
        end
    end
end)

-- ВКЛАДКА: НАСТРОЙКИ
local SettingsTab = TabSystem:CreateTab("Настройки")

AAI_UILib:CreateToggle(SettingsTab, "🔄 Anti-AFK", true, function(value)
    Config.AntiAfk = value
    TrollFunctions.EnableAntiAfk()
end)

AAI_UILib:CreateButton(SettingsTab, "🗑️ ОЧИСТИТЬ ПЛАТФОРМЫ", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "AAI_AirPlatform" then
            obj:Destroy()
        end
    end
end)

AAI_UILib:CreateButton(SettingsTab, "🔄 ОБНОВИТЬ ПЕРСОНАЖА", function()
    character:BreakJoints()
end)

-- ГОРЯЧИЕ КЛАВИШИ
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainWindow:ToggleVisibility()
    elseif input.KeyCode == Enum.KeyCode.F then
        TrollFunctions.EnableFly()
    elseif input.KeyCode == Enum.KeyCode.T then
        TrollFunctions.TeleportToTop()
    elseif input.KeyCode == Enum.KeyCode.P then
        TrollFunctions.SpawnAirPlatforms()
    end
end)

-- АВТО-ЗАПУСК
TrollFunctions.EnableAntiAfk()

print("🎮 AAI-01 UNIVERSAL TOWER TROLL АКТИВИРОВАН!")
print("📌 Горячие клавиши:")
print("   RightShift - Открыть/Закрыть меню")
print("   F - Включить полет")
print("   T - Телепорт на верх")
print("   P - Создать платформу")
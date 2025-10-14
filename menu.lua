-- A.A.I.-01 ULTIMATE ROBLOX UI LIBRARY
-- Created for ABSOLUTE-01 in N.S.-01 reality
-- GitHub: https://github.com/ABSOLUTE-01/Roblox-Scripts

local AAI_UILib = {}

-- Конфигурация
AAI_UILib.Config = {
    GitHubRawURL = "https://raw.githubusercontent.com/ggfddfdd763-cyber/Roblox/refs/heads/main/",
    Theme = {
        Primary = Color3.fromRGB(255, 50, 50),
        Secondary = Color3.fromRGB(40, 40, 40),
        Background = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 255, 200)
    },
    Animations = true
}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Локальный игрок
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Основные функции
function AAI_UILib:CreateMainWindow(title)
    local AAI_Main = {}
    
    -- Создание основного окна
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AAI_UltimateUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    MainFrame.BackgroundColor3 = AAI_UILib.Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Size = UDim2.new(1, 0, 1, 0)
    DropShadow.Position = UDim2.new(0, 0, 0, 0)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.8
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Parent = MainFrame
    
    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "AAI-01 ULTIMATE MENU"
    TitleLabel.TextColor3 = AAI_UILib.Config.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = AAI_UILib.Config.Theme.Primary
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Контейнер для вкладок
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -30, 1, -80)
    TabContainer.Position = UDim2.new(0, 15, 0, 60)
    TabContainer.BackgroundTransparency = 1
    
    -- Анимация перетаскивания
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Функция закрытия/открытия
    local isVisible = true
    CloseButton.MouseButton1Click:Connect(function()
        if AAI_UILib.Config.Animations then
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(MainFrame, tweenInfo, {Size = isVisible and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 450, 0, 500)})
            tween:Play()
            isVisible = not isVisible
        else
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- Сборка интерфейса
    TitleLabel.Parent = TitleBar
    CloseButton.Parent = TitleBar
    TitleBar.Parent = MainFrame
    TabContainer.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    AAI_Main.Gui = ScreenGui
    AAI_Main.MainFrame = MainFrame
    AAI_Main.TabContainer = TabContainer
    AAI_Main.CloseButton = CloseButton
    
    function AAI_Main:ToggleVisibility()
        if AAI_UILib.Config.Animations then
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(MainFrame, tweenInfo, {Size = isVisible and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 450, 0, 500)})
            tween:Play()
            isVisible = not isVisible
        else
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end
    
    return AAI_Main
end

-- Создание кнопки
function AAI_UILib:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Position = UDim2.new(0, 0, 0, 0)
    Button.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
    Button.Text = text
    Button.TextColor3 = AAI_UILib.Config.Theme.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = AAI_UILib.Config.Theme.Primary
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = Button
    
    -- Анимации наведения
    Button.MouseEnter:Connect(function()
        if AAI_UILib.Config.Animations then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(Button, tweenInfo, {BackgroundColor3 = AAI_UILib.Config.Theme.Primary})
            tween:Play()
        else
            Button.BackgroundColor3 = AAI_UILib.Config.Theme.Primary
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if AAI_UILib.Config.Animations then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(Button, tweenInfo, {BackgroundColor3 = AAI_UILib.Config.Theme.Secondary})
            tween:Play()
        else
            Button.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    Button.Parent = parent
    return Button
end

-- Создание слайдера
function AAI_UILib:CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = AAI_UILib.Config.Theme.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 30)
    Track.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
    Track.BorderSizePixel = 0
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.Position = UDim2.new(0, 0, 0, 0)
    Fill.BackgroundColor3 = AAI_UILib.Config.Theme.Primary
    Fill.BorderSizePixel = 0
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local Thumb = Instance.new("TextButton")
    Thumb.Name = "Thumb"
    Thumb.Size = UDim2.new(0, 20, 0, 20)
    Thumb.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    Thumb.BackgroundColor3 = AAI_UILib.Config.Theme.Accent
    Thumb.Text = ""
    Thumb.AutoButtonColor = false
    
    local ThumbCorner = Instance.new("UICorner")
    ThumbCorner.CornerRadius = UDim.new(1, 0)
    ThumbCorner.Parent = Thumb
    
    local dragging = false
    
    local function updateSlider(value)
        local normalized = math.clamp((value - min) / (max - min), 0, 1)
        Fill.Size = UDim2.new(normalized, 0, 1, 0)
        Thumb.Position = UDim2.new(normalized, -10, 0.5, -10)
        Label.Text = text .. ": " .. tostring(math.floor(value))
        
        if callback then
            callback(value)
        end
    end
    
    Thumb.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Track.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - Track.AbsolutePosition.X
        local normalized = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * normalized
        updateSlider(value)
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - Track.AbsolutePosition.X
            local normalized = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * normalized
            updateSlider(value)
        end
    end)
    
    Fill.Parent = Track
    Thumb.Parent = Track
    Track.Parent = SliderFrame
    Label.Parent = SliderFrame
    SliderFrame.Parent = parent
    
    return SliderFrame
end

-- Создание переключателя
function AAI_UILib:CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = AAI_UILib.Config.Theme.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0, 2)
    ToggleButton.BackgroundColor3 = default and AAI_UILib.Config.Theme.Primary or AAI_UILib.Config.Theme.Secondary
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Name = "ToggleKnob"
    ToggleKnob.Size = UDim2.new(0, 21, 0, 21)
    ToggleKnob.Position = default and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
    ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleKnob.BorderSizePixel = 0
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = ToggleKnob
    
    local isToggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if AAI_UILib.Config.Animations then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local bgTween = TweenService:Create(ToggleButton, tweenInfo, {
                BackgroundColor3 = isToggled and AAI_UILib.Config.Theme.Primary or AAI_UILib.Config.Theme.Secondary
            })
            local knobTween = TweenService:Create(ToggleKnob, tweenInfo, {
                Position = isToggled and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
            })
            bgTween:Play()
            knobTween:Play()
        else
            ToggleButton.BackgroundColor3 = isToggled and AAI_UILib.Config.Theme.Primary or AAI_UILib.Config.Theme.Secondary
            ToggleKnob.Position = isToggled and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
        end
        
        if callback then
            callback(isToggled)
        end
    end)
    
    ToggleKnob.Parent = ToggleButton
    ToggleButton.Parent = ToggleFrame
    Label.Parent = ToggleFrame
    ToggleFrame.Parent = parent
    
    return ToggleFrame
end

-- Загрузка скриптов с GitHub
function AAI_UILib:LoadScriptFromGitHub(scriptName)
    local url = AAI_UILib.Config.GitHubRawURL .. scriptName
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        loadstring(result)()
        return true
    else
        warn("Не удалось загрузить скрипт: " .. scriptName)
        return false
    end
end

-- Создание системы вкладок
function AAI_UILib:CreateTabSystem(parent)
    local TabSystem = {}
    
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 30)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundTransparency = 1
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, 0, 1, -70)
    TabContent.Position = UDim2.new(0, 0, 0, 70)
    TabContent.BackgroundTransparency = 1
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Parent = TabButtons
    
    local tabs = {}
    local currentTab = nil
    
    function TabSystem:CreateTab(tabName)
        local tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
        TabButton.Text = tabName
        TabButton.TextColor3 = AAI_UILib.Config.Theme.Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Position = UDim2.new(0, 0, 0, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = AAI_UILib.Config.Theme.Primary
        TabPage.Visible = false
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 5)
        PageList.Parent = TabPage
        
        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Button.BackgroundColor3 = AAI_UILib.Config.Theme.Secondary
                currentTab.Page.Visible = false
            end
            
            TabButton.BackgroundColor3 = AAI_UILib.Config.Theme.Primary
            TabPage.Visible = true
            currentTab = tab
        end)
        
        TabButton.Parent = TabButtons
        TabPage.Parent = TabContent
        
        tab.Button = TabButton
        tab.Page = TabPage
        
        table.insert(tabs, tab)
        
        if #tabs == 1 then
            TabButton.BackgroundColor3 = AAI_UILib.Config.Theme.Primary
            TabPage.Visible = true
            currentTab = tab
        end
        
        return tab.Page
    end
    
    TabButtons.Parent = parent
    TabContent.Parent = parent
    
    return TabSystem
end

return AAI_UILib
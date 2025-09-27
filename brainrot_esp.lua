-- Snow Hub ESP com menu centralizado animado

local lp = game.Players.LocalPlayer
local playerESPs = {}
local baseESPs = {}
local enabledPlayerESP = false
local enabledBaseESP = false

-- Função: pinta personagem de vermelho
local function paintChar(char)
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            obj.Color = Color3.fromRGB(255, 0, 0)
            obj.Material = Enum.Material.Neon
        end
    end
end

-- ESP dos players
local function createPlayerESP()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("Head") then
            paintChar(player.Character)
            local billboard = Instance.new("BillboardGui", player.Character.Head)
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.Adornee = player.Character.Head
            billboard.AlwaysOnTop = true
            billboard.Name = "PlayerESP"
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.SourceSansBold
            label.TextScaled = true
            label.Text = player.Name
            table.insert(playerESPs, billboard)
        end
    end
end

local function removePlayerESP()
    for _, esp in ipairs(playerESPs) do
        esp:Destroy()
    end
    playerESPs = {}
end

-- ESP das bases
local function createBaseESP()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name:lower():find("base") then
            local billboard = Instance.new("BillboardGui", obj)
            billboard.Size = UDim2.new(0, 150, 0, 40)
            billboard.Adornee = obj
            billboard.AlwaysOnTop = true
            billboard.Name = "BaseESP"
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(0, 255, 255)
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.SourceSansBold
            label.TextScaled = true
            label.Text = obj.Name
            table.insert(baseESPs, billboard)
        end
    end
end

local function removeBaseESP()
    for _, esp in ipairs(baseESPs) do
        esp:Destroy()
    end
    baseESPs = {}
end

-- GUI do menu centralizado
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "SnowHubMenu"
menuGui.Parent = game.CoreGui

local frame = Instance.new("Frame", menuGui)
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.5, -130, 0, -200) -- Começa fora da tela
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 230, 255)
title.TextStrokeTransparency = 0
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "Snow Hub"

local opt1 = Instance.new("TextButton", frame)
opt1.Size = UDim2.new(1, -40, 0, 32)
opt1.Position = UDim2.new(0, 20, 0, 60)
opt1.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt1.TextColor3 = Color3.fromRGB(255,255,255)
opt1.Font = Enum.Font.Gotham
opt1.TextScaled = true
opt1.Text = "Player ESP: OFF"

local opt2 = Instance.new("TextButton", frame)
opt2.Size = UDim2.new(1, -40, 0, 32)
opt2.Position = UDim2.new(0, 20, 0, 100)
opt2.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt2.TextColor3 = Color3.fromRGB(255,255,255)
opt2.Font = Enum.Font.Gotham
opt2.TextScaled = true
opt2.Text = "Base ESP: OFF"

local opt3 = Instance.new("TextButton", frame)
opt3.Size = UDim2.new(1, -40, 0, 32)
opt3.Position = UDim2.new(0, 20, 0, 140)
opt3.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt3.TextColor3 = Color3.fromRGB(255,255,255)
opt3.Font = Enum.Font.Gotham
opt3.TextScaled = true
opt3.Text = "Fechar Menu"

frame.Visible = false

-- Animação do menu descendo
local function showMenu()
    frame.Visible = true
    for i = 0, 20 do
        frame.Position = UDim2.new(0.5, -130, 0, -200 + i*12)
        wait(0.01)
    end
    frame.Position = UDim2.new(0.5, -130, 0.5, -95)
end

local function hideMenu()
    for i = 20, 0, -1 do
        frame.Position = UDim2.new(0.5, -130, 0, -200 + i*12)
        wait(0.01)
    end
    frame.Visible = false
end

-- Botões do menu
opt1.MouseButton1Click:Connect(function()
    enabledPlayerESP = not enabledPlayerESP
    opt1.Text = enabledPlayerESP and "Player ESP: ON" or "Player ESP: OFF"
    if enabledPlayerESP then
        createPlayerESP()
    else
        removePlayerESP()
    end
end)

opt2.MouseButton1Click:Connect(function()
    enabledBaseESP = not enabledBaseESP
    opt2.Text = enabledBaseESP and "Base ESP: ON" or "Base ESP: OFF"
    if enabledBaseESP then
        createBaseESP()
    else
        removeBaseESP()
    end
end)

opt3.MouseButton1Click:Connect(function()
    hideMenu()
end)

-- Abrir menu com a tecla M
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        showMenu()
    end
end)

-- Mensagem inicial
game.StarterGui:SetCore("SendNotification", {
    Title = "Snow Hub",
    Text = "Pressione M para abrir o menu!",
    Duration = 6
})

-- DICA: Para ESP do tempo da base funcionar, preciso saber onde está o valor do tempo nas bases do seu jogo!

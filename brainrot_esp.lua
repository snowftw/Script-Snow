-- MENU BONITINHO + ESP PLAYERS + ESP BASE
local lp = game.Players.LocalPlayer
local enabledPlayerESP = false
local enabledBaseESP = false
local playerESPs = {}
local baseESPs = {}

-- Função para pintar personagem de vermelho
local function paintChar(char)
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            obj.Color = Color3.fromRGB(255, 0, 0)
            obj.Material = Enum.Material.Neon
        end
    end
end

-- Função para criar ESP dos players
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

-- Função para remover ESP dos players
local function removePlayerESP()
    for _, esp in ipairs(playerESPs) do
        esp:Destroy()
    end
    playerESPs = {}
end

-- Função para criar ESP das bases
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

-- Função para remover ESP das bases
local function removeBaseESP()
    for _, esp in ipairs(baseESPs) do
        esp:Destroy()
    end
    baseESPs = {}
end

-- Menu simples usando Notify
local function showMenu()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Brainrot Menu",
        Text = "1: Toggle Player ESP\n2: Toggle Base ESP\n3: Remover Todos\n4: Fechar Menu",
        Duration = 8
    })
end

-- Evento do teclado para menu
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        showMenu()
    elseif input.KeyCode == Enum.KeyCode.One then
        enabledPlayerESP = not enabledPlayerESP
        if enabledPlayerESP then
            createPlayerESP()
        else
            removePlayerESP()
        end
    elseif input.KeyCode == Enum.KeyCode.Two then
        enabledBaseESP = not enabledBaseESP
        if enabledBaseESP then
            createBaseESP()
        else
            removeBaseESP()
        end
    elseif input.KeyCode == Enum.KeyCode.Three then
        removePlayerESP()
        removeBaseESP()
        enabledPlayerESP = false
        enabledBaseESP = false
    elseif input.KeyCode == Enum.KeyCode.Four then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Brainrot Menu",
            Text = "Menu Fechado!",
            Duration = 3
        })
    end
end)

-- Mensagem inicial
game.StarterGui:SetCore("SendNotification", {
    Title = "Brainrot ESP",
    Text = "Pressione M para abrir o menu!",
    Duration = 6
})

-- Snow Hub: ESP completo, menu bonito, speed/pulo, nick vermelho, corpo vermelho, base ESP, melhor brainrot

local lp = game.Players.LocalPlayer
local playerESPs, baseESPs, bestBrainrotESP = {}, {}, nil
local enabledPlayerESP, enabledBaseESP = false, false
local walkSpeed, jumpPower = 16, 50

-- Atualiza velocidade e pulo SEMPRE
local function updateStats()
    if lp.Character then
        local hum = lp.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = walkSpeed
            hum.JumpPower = jumpPower
        end
    end
end
lp.CharacterAdded:Connect(function()
    wait(0.2)
    updateStats()
end)

-- Força todos os players a ficarem vermelhos (corpo e nick)
local function paintCharAll()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character then
            for _, obj in ipairs(player.Character:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    obj.Color = Color3.fromRGB(255, 0, 0)
                    obj.Material = Enum.Material.Neon
                end
                if obj:IsA("Accessory") and obj:FindFirstChild("Handle") then
                    obj.Handle.Color = Color3.fromRGB(255,0,0)
                    obj.Handle.Material = Enum.Material.Neon
                end
            end
        end
    end
end

-- ESP dos players: nome vermelho acima da cabeça
local function createPlayerESP()
    removePlayerESP()
    paintCharAll()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("Head") then
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
            label.Font = Enum.Font.GothamBlack
            label.TextScaled = true
            label.Text = player.Name
            table.insert(playerESPs, billboard)
        end
        player.CharacterAdded:Connect(function(char)
            wait(0.2)
            paintCharAll()
            if enabledPlayerESP and char:FindFirstChild("Head") then
                local billboard = Instance.new("BillboardGui", char.Head)
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.Adornee = char.Head
                billboard.AlwaysOnTop = true
                billboard.Name = "PlayerESP"
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBlack
                label.TextScaled = true
                label.Text = player.Name
                table.insert(playerESPs, billboard)
            end
        end)
    end
end

local function removePlayerESP()
    for _, esp in ipairs(playerESPs) do esp:Destroy() end
    playerESPs = {}
end

-- ESP das bases (aparece em TODAS as bases do mapa)
local function createBaseESP()
    removeBaseESP()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name:lower():find("base") then
            local billboard = Instance.new("BillboardGui", obj)
            billboard.Size = UDim2.new(0, 150, 0, 55)
            billboard.Adornee = obj
            billboard.AlwaysOnTop = true
            billboard.Name = "BaseESP"
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(0, 255, 255)
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
            -- Tenta pegar timer da base (edite para o nome correto se souber)
            local time = "?"
            for _, v in ipairs(obj:GetChildren()) do
                if v:IsA("NumberValue") and (v.Name:lower():find("timer") or v.Name:lower():find("decay") or v.Name:lower():find("time")) then
                    time = math.floor(v.Value)
                    v:GetPropertyChangedSignal("Value"):Connect(function()
                        label.Text = obj.Name .. "\nTempo: " .. math.floor(v.Value) .. "s"
                    end)
                    break
                end
            end
            label.Text = obj.Name .. "\nTempo: " .. time .. "s"
            table.insert(baseESPs, billboard)
        end
    end
end

local function removeBaseESP()
    for _, esp in ipairs(baseESPs) do esp:Destroy() end
    baseESPs = {}
end

-- ESP do melhor brainrot do server
local function createBestBrainrotESP()
    if bestBrainrotESP then bestBrainrotESP:Destroy() end
    local bestPlayer, bestValue = nil, -math.huge
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Brainrot") then
            local value = player.leaderstats.Brainrot.Value
            if value > bestValue then
                bestValue = value
                bestPlayer = player
            end
        end
    end
    if bestPlayer and bestPlayer ~= lp and bestPlayer.Character and bestPlayer.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui", bestPlayer.Character.Head)
        billboard.Size = UDim2.new(0, 180, 0, 50)
        billboard.Adornee = bestPlayer.Character.Head
        billboard.AlwaysOnTop = true
        billboard.Name = "BestBrainrotESP"
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.Text = "Melhor Brainrot:\n" .. bestPlayer.Name .. "\n" .. bestValue
        bestBrainrotESP = billboard
    end
end

local function removeBestBrainrotESP()
    if bestBrainrotESP then bestBrainrotESP:Destroy() end
    bestBrainrotESP = nil
end

-- Menu estiloso centralizado
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "SnowHubMenu"
menuGui.Parent = game.CoreGui

local frame = Instance.new("Frame", menuGui)
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0.5, -160, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.12
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Visible = false
local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 52)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(80, 225, 255)
title.TextStrokeTransparency = 0
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Text = "Snow Hub"
title.ZIndex = 11

local opt1 = Instance.new("TextButton", frame)
opt1.Size = UDim2.new(1, -40, 0, 32)
opt1.Position = UDim2.new(0, 20, 0, 60)
opt1.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt1.TextColor3 = Color3.fromRGB(255,255,255)
opt1.Font = Enum.Font.GothamBold
opt1.TextScaled = true
opt1.Text = "Player ESP: OFF"
local UICorner1 = Instance.new("UICorner", opt1)
UICorner1.CornerRadius = UDim.new(0, 12)

local opt2 = Instance.new("TextButton", frame)
opt2.Size = UDim2.new(1, -40, 0, 32)
opt2.Position = UDim2.new(0, 20, 0, 100)
opt2.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt2.TextColor3 = Color3.fromRGB(255,255,255)
opt2.Font = Enum.Font.GothamBold
opt2.TextScaled = true
opt2.Text = "Base ESP: OFF"
local UICorner2 = Instance.new("UICorner", opt2)
UICorner2.CornerRadius = UDim.new(0, 12)

local opt3 = Instance.new("TextButton", frame)
opt3.Size = UDim2.new(1, -40, 0, 32)
opt3.Position = UDim2.new(0, 20, 0, 140)
opt3.BackgroundColor3 = Color3.fromRGB(40,40,40)
opt3.TextColor3 = Color3.fromRGB(255,255,255)
opt3.Font = Enum.Font.GothamBold
opt3.TextScaled = true
opt3.Text = "Melhor Brainrot: OFF"
local UICorner3 = Instance.new("UICorner", opt3)
UICorner3.CornerRadius = UDim.new(0, 12)

-- Slider para velocidade
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0.5, -20, 0, 28)
speedLabel.Position = UDim2.new(0, 20, 0, 180)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(120,255,120)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.Text = "Velocidade: " .. walkSpeed

local speedInc = Instance.new("TextButton", frame)
speedInc.Size = UDim2.new(0, 28, 0, 28)
speedInc.Position = UDim2.new(0, 170, 0, 180)
speedInc.Text = "+"
speedInc.Font = Enum.Font.GothamBold
speedInc.TextScaled = true
speedInc.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedInc.TextColor3 = Color3.fromRGB(255,255,255)

local speedDec = Instance.new("TextButton", frame)
speedDec.Size = UDim2.new(0, 28, 0, 28)
speedDec.Position = UDim2.new(0, 210, 0, 180)
speedDec.Text = "-"
speedDec.Font = Enum.Font.GothamBold
speedDec.TextScaled = true
speedDec.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedDec.TextColor3 = Color3.fromRGB(255,255,255)

-- Slider para pulo
local jumpLabel = Instance.new("TextLabel", frame)
jumpLabel.Size = UDim2.new(0.5, -20, 0, 28)
jumpLabel.Position = UDim2.new(0, 20, 0, 215)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.fromRGB(120,180,255)
jumpLabel.Font = Enum.Font.GothamBold
jumpLabel.TextScaled = true
jumpLabel.Text = "Pulo: " .. jumpPower

local jumpInc = Instance.new("TextButton", frame)
jumpInc.Size = UDim2.new(0, 28, 0, 28)
jumpInc.Position = UDim2.new(0, 170, 0, 215)
jumpInc.Text = "+"
jumpInc.Font = Enum.Font.GothamBold
jumpInc.TextScaled = true
jumpInc.BackgroundColor3 = Color3.fromRGB(60,60,60)
jumpInc.TextColor3 = Color3.fromRGB(255,255,255)

local jumpDec = Instance.new("TextButton", frame)
jumpDec.Size = UDim2.new(0, 28, 0, 28)
jumpDec.Position = UDim2.new(0, 210, 0, 215)
jumpDec.Text = "-"
jumpDec.Font = Enum.Font.GothamBold
jumpDec.TextScaled = true
jumpDec.BackgroundColor3 = Color3.fromRGB(60,60,60)
jumpDec.TextColor3 = Color3.fromRGB(255,255,255)

local optClose = Instance.new("TextButton", frame)
optClose.Size = UDim2.new(1, -40, 0, 32)
optClose.Position = UDim2.new(0, 20, 0, 250)
optClose.BackgroundColor3 = Color3.fromRGB(40,40,40)
optClose.TextColor3 = Color3.fromRGB(255,255,255)
optClose.Font = Enum.Font.GothamBold
optClose.TextScaled = true
optClose.Text = "Fechar Menu"
local UICorner4 = Instance.new("UICorner", optClose)
UICorner4.CornerRadius = UDim.new(0, 12)

-- Botões do menu
opt1.MouseButton1Click:Connect(function()
    enabledPlayerESP = not enabledPlayerESP
    opt1.Text = enabledPlayerESP and "Player ESP: ON" or "Player ESP: OFF"
    if enabledPlayerESP then createPlayerESP() else removePlayerESP() end
end)

opt2.MouseButton1Click:Connect(function()
    enabledBaseESP = not enabledBaseESP
    opt2.Text = enabledBaseESP and "Base ESP: ON" or "Base ESP: OFF"
    if enabledBaseESP then createBaseESP() else removeBaseESP() end
end)

opt3.MouseButton1Click:Connect(function()
    if bestBrainrotESP then
        removeBestBrainrotESP()
        opt3.Text = "Melhor Brainrot: OFF"
    else
        createBestBrainrotESP()
        opt3.Text = "Melhor Brainrot: ON"
    end
end)

optClose.MouseButton1Click:Connect(function() frame.Visible = false end)

speedInc.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed + 5, 1, 100)
    speedLabel.Text = "Velocidade: " .. walkSpeed
    updateStats()
end)
speedDec.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed - 5, 1, 100)
    speedLabel.Text = "Velocidade: " .. walkSpeed
    updateStats()
end)

jumpInc.MouseButton1Click:Connect(function()
    jumpPower = math.clamp(jumpPower + 5, 1, 100)
    jumpLabel.Text = "Pulo: " .. jumpPower
    updateStats()
end)
jumpDec.MouseButton1Click:Connect(function()
    jumpPower = math.clamp(jumpPower - 5, 1, 100)
    jumpLabel.Text = "Pulo: " .. jumpPower
    updateStats()
end)

-- Abrir menu com M
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)

-- Mensagem inicial
game.StarterGui:SetCore("SendNotification", {
    Title = "Snow Hub",
    Text = "Pressione M para abrir o menu!",
    Duration = 6
})

-- Para ESP do tempo das bases mostrar o tempo real, troque "timer", "time", "decay" para o nome correto do valor se souber!
-- Para ESP do melhor brainrot funcionar, seu jogo precisa ter leaderstats.Brainrot nos players!

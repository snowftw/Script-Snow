-- Deixa os outros personagens vermelhos (menos o seu)
local lp = game.Players.LocalPlayer

for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= lp then
        local function paintChar(char)
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    obj.Color = Color3.fromRGB(255, 0, 0)
                    obj.Material = Enum.Material.Neon
                end
            end
        end
        if player.Character then
            paintChar(player.Character)
        end
        player.CharacterAdded:Connect(paintChar)
    end
end

-- ESP do tempo da base (simples, adaptável)
for _, obj in ipairs(workspace:GetChildren()) do
    if obj.Name:lower():find("base") then
        local billboard = Instance.new("BillboardGui", obj)
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.Adornee = obj
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0,255,255)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true
        label.Text = "Tempo: ?s"
        -- Se houver um valor real do tempo da base, coloque aqui:
        -- label.Text = "Tempo: " .. tostring(obj.Tempo.Value) .. "s"
    end
end

-- ESP do melhor brainrot do servidor (adaptável)
local bestPlayer = nil
local bestBrainrot = -math.huge
for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= lp then
        -- Tente pegar leaderstats.Brainrot (adapte para o seu jogo!)
        local stats = player:FindFirstChild("leaderstats")
        if stats and stats:FindFirstChild("Brainrot") then
            local value = stats.Brainrot.Value
            if value > bestBrainrot then
                bestBrainrot = value
                bestPlayer = player
            end
        end
    end
end

if bestPlayer and bestPlayer.Character and bestPlayer.Character:FindFirstChild("Head") then
    local esp = Instance.new("BillboardGui", bestPlayer.Character.Head)
    esp.Size = UDim2.new(0,200,0,50)
    esp.Adornee = bestPlayer.Character.Head
    esp.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", esp)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255,255,0)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.SourceSansBold
    txt.TextScaled = true
    txt.Text = "MELHOR BRAINROT\n" .. bestPlayer.Name .. ": " .. bestBrainrot
end

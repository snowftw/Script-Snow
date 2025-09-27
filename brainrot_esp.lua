-- Exemplo simples para Xeno/Roblox
game.StarterGui:SetCore("SendNotification", {
    Title = "Brainrot ESP";
    Text = "Script carregado!";
    Duration = 5;
})

-- ESP básico para todos os players (nome acima da cabeça)
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        local char = player.Character or player.CharacterAdded:Wait()
        if char:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui", char.Head)
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.Adornee = char.Head
            billboard.AlwaysOnTop = true

            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1, 0, 1, 0)
            text.Text = player.Name
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 0, 0)
            text.TextStrokeTransparency = 0
            text.Font = Enum.Font.SourceSansBold
            text.TextScaled = true
        end
    end
end

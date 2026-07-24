-- ==================== BUSCADOR MELHORADO ====================
local function SearchForValue(targetValue)
    -- Limpa buscas anteriores
    for _, hl in ipairs(tempHighlights) do pcall(function() hl:Destroy() end) end
    tempHighlights = {}

    local found = 0
    local checked = 0

    -- Lugares para procurar (mais completo)
    local searchPlaces = {
        player,
        player.Character,
        player:FindFirstChild("leaderstats"),
        player:FindFirstChild("PlayerGui"),
        player.Backpack,
        Workspace,
        game.ReplicatedStorage,
        game.StarterPlayer
    }

    for _, place in ipairs(searchPlaces) do
        if place then
            for _, obj in ipairs(place:GetDescendants()) do
                checked = checked + 1
                if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
                    if tonumber(obj.Value) == targetValue then
                        local highlightParent = nil
                        
                        -- Tenta encontrar um objeto visível para destacar
                        if obj.Parent and obj.Parent:IsA("BasePart") then
                            highlightParent = obj.Parent
                        elseif obj.Parent and obj.Parent:FindFirstChild("Humanoid") then
                            highlightParent = obj.Parent
                        elseif obj.Parent and (obj.Parent.Name:lower():find("leader") or obj.Name:lower():find("money") or obj.Name:lower():find("coin")) then
                            highlightParent = player.Character or player
                        else
                            -- Se não achar um bom parent, destaca o próprio valor
                            highlightParent = obj.Parent or player.Character
                        end
                        
                        if highlightParent then
                            CreateHighlight(highlightParent, Color3.fromHex("#00ff00"), true)
                            found = found + 1
                            
                            -- Print no console para debug
                            print("Encontrado:", obj:GetFullName(), "Valor:", obj.Value)
                        end
                    end
                end
            end
        end
    end

    Rayfield:Notify({
        Title = "Busca Finalizada",
        Content = found .. " valor(es) encontrado(s) | Verifique o console (F9)",
        Duration = 8
    })

    if found == 0 then
        Rayfield:Notify({
            Title = "Nada Encontrado",
            Content = "Tente novamente ou verifique o console (F9)",
            Duration = 6
        })
    end

    -- Remove highlights depois de 15 segundos
    task.delay(15, function()
        for _, hl in ipairs(tempHighlights) do pcall(function() hl:Destroy() end) end
        tempHighlights = {}
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "# Murder Nice",
   LoadingTitle = "Murder Mystery 2",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local player = Players.LocalPlayer

-- ==================== VARIÁVEIS ====================
local highlights = {}

local ESP = {
    Murderer = {Enabled = false, Color = Color3.fromHex("#ff1100")},
    Sheriff = {Enabled = false, Color = Color3.fromHex("#5696e3")},
    Players = {Enabled = false, Color = Color3.fromHex("#c452c4")}
}

-- ==================== FUNÇÕES ====================
local function ClearHighlights()
    for _, hl in ipairs(highlights) do
        pcall(function() hl:Destroy() end)
    end
    highlights = {}
end

local function CreateHighlight(target, color)
    if not target or target:FindFirstChild("MM2ESP") then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "MM2ESP"
    hl.Adornee = target
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0.25
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target
    table.insert(highlights, hl)
end

local function GetRole(plr)
    if not plr or plr == player then return "None" end
    
    local backpack = plr:FindFirstChild("Backpack")
    local character = plr.Character
    
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") or name:find("murd") then return "Murderer" end
                if name:find("gun") or name:find("pistol") or name:find("sheriff") then return "Sheriff" end
            end
        end
    end
    
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") or name:find("murd") then return "Murderer" end
                if name:find("gun") or name:find("pistol") or name:find("sheriff") then return "Sheriff" end
            end
        end
    end
    
    return "Innocent"
end

local function UpdateESP()
    ClearHighlights()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == player or not plr.Character then continue end
        local role = GetRole(plr)
        
        if ESP.Murderer.Enabled and role == "Murderer" then
            CreateHighlight(plr.Character, ESP.Murderer.Color)
        end
        if ESP.Sheriff.Enabled and role == "Sheriff" then
            CreateHighlight(plr.Character, ESP.Sheriff.Color)
        end
        if ESP.Players.Enabled then
            CreateHighlight(plr.Character, ESP.Players.Color)
        end
    end
end

-- ==================== DETECÇÃO AUTOMÁTICA DE MOEDA ====================
local function GetMoneyValue()
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return nil end

    -- Possíveis nomes comuns de moeda
    local possibleNames = {"Money", "Coins", "Cash", "Points", "Gold", "Balance", "Currency"}
    
    for _, name in ipairs(possibleNames) do
        local value = leaderstats:FindFirstChild(name)
        if value and (value:IsA("IntValue") or value:IsA("NumberValue")) then
            return value
        end
    end
    
    -- Se não encontrar pelo nome, pega o primeiro valor numérico
    for _, v in pairs(leaderstats:GetChildren()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") then
            return v
        end
    end
    
    return nil
end

local function AddMoney(amount)
    if not amount or amount <= 0 then 
        Rayfield:Notify({Title = "Erro", Content = "Digite um valor válido!", Duration = 3})
        return 
    end

    local moneyValue = GetMoneyValue()
    
    if moneyValue then
        local targetValue = moneyValue.Value + amount
        moneyValue.Value = targetValue
        
        -- Força o valor por alguns segundos
        task.spawn(function()
            for i = 1, 25 do
                if moneyValue.Value < targetValue then
                    moneyValue.Value = targetValue
                end
                task.wait(0.1)
            end
        end)

        Rayfield:Notify({
            Title = "Sucesso!", 
            Content = "Adicionado +" .. amount .. " (" .. moneyValue.Name .. ")", 
            Duration = 5
        })
    else
        Rayfield:Notify({
            Title = "Erro", 
            Content = "Não foi possível encontrar o sistema de dinheiro.", 
            Duration = 5
        })
    end
end

-- ==================== UI ====================
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local EspTab = Window:CreateTab("ESP", 4483362458)
local MoneyTab = Window:CreateTab("💰 Money", 6031097228)

-- Main
MainTab:CreateSection("Murder Nice")

-- ESP
EspTab:CreateSection("Visualizar Murderer")
EspTab:CreateToggle({Name = "Visualizar Murderer", CurrentValue = false, Callback = function(v) ESP.Murderer.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor do Murderer", Color = ESP.Murderer.Color, Callback = function(v) ESP.Murderer.Color = v end})

EspTab:CreateSection("Visualizar Xerife")
EspTab:CreateToggle({Name = "Visualizar Xerife", CurrentValue = false, Callback = function(v) ESP.Sheriff.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor do Xerife", Color = ESP.Sheriff.Color, Callback = function(v) ESP.Sheriff.Color = v end})

EspTab:CreateSection("Visualizar Players")
EspTab:CreateToggle({Name = "Visualizar Todos os Players", CurrentValue = false, Callback = function(v) ESP.Players.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor dos Players", Color = ESP.Players.Color, Callback = function(v) ESP.Players.Color = v end})

-- Money
MoneyTab:CreateSection("Adicionar Dinheiro")

local MoneyInput = MoneyTab:CreateInput({
   Name = "Quantidade",
   PlaceholderText = "Ex: 10000",
   RemoveTextOnFocusLost = false,
   Callback = function() end,
})

MoneyTab:CreateButton({
   Name = "+ Adicionar Dinheiro",
   Callback = function()
      local amount = tonumber(MoneyInput.CurrentValue)
      if amount then
         AddMoney(amount)
      else
         Rayfield:Notify({Title = "Erro", Content = "Digite um número válido!", Duration = 3})
      end
   end,
})

-- Loop
RunService.RenderStepped:Connect(function()
    if ESP.Murderer.Enabled or ESP.Sheriff.Enabled or ESP.Players.Enabled then
        UpdateESP()
    else
        ClearHighlights()
    end
end)

Rayfield:Notify({
   Title = "Murder Nice 1.1",
   Content = "Script carregado! (Detector de moeda automático)",
   Duration = 6,
})

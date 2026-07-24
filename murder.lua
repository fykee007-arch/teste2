local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "# Murder Nice",
   LoadingTitle = "Murder Mystery 2",
   LoadingSubtitle = "by FyKe",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local player = Players.LocalPlayer

-- ==================== VARIÁVEIS ====================
local highlights = {}
local tempHighlights = {} -- Para o buscador

local ESP = {
    Murderer = {Enabled = false, Color = Color3.fromHex("#ff1100")},
    Sheriff = {Enabled = false, Color = Color3.fromHex("#5696e3")},
    Players = {Enabled = false, Color = Color3.fromHex("#c452c4")}
}

-- ==================== FUNÇÕES GERAIS ====================
local function ClearHighlights()
    for _, hl in ipairs(highlights) do pcall(function() hl:Destroy() end) end
    highlights = {}
end

local function CreateHighlight(target, color, temporary)
    if not target then return end
    if target:FindFirstChild("MM2ESP") then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "MM2ESP"
    hl.Adornee = target
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.7
    hl.OutlineTransparency = 0.2
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target
    
    if temporary then
        table.insert(tempHighlights, hl)
    else
        table.insert(highlights, hl)
    end
    return hl
end

local function GetRole(plr)
    if not plr or plr == player then return "None" end
    local backpack = plr:FindFirstChild("Backpack")
    local character = plr.Character
    
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("murd") then return "Murderer" end
                if n:find("gun") or n:find("pistol") or n:find("sheriff") then return "Sheriff" end
            end
        end
    end
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("murd") then return "Murderer" end
                if n:find("gun") or n:find("pistol") or n:find("sheriff") then return "Sheriff" end
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
        if ESP.Murderer.Enabled and role == "Murderer" then CreateHighlight(plr.Character, ESP.Murderer.Color) end
        if ESP.Sheriff.Enabled and role == "Sheriff" then CreateHighlight(plr.Character, ESP.Sheriff.Color) end
        if ESP.Players.Enabled then CreateHighlight(plr.Character, ESP.Players.Color) end
    end
end

-- ==================== BUSCADOR DE MOEDA ====================
local function SearchForValue(targetValue)
    -- Limpa buscas anteriores
    for _, hl in ipairs(tempHighlights) do pcall(function() hl:Destroy() end) end
    tempHighlights = {}

    local found = 0
    local searchPlaces = {player, player.Character, player:FindFirstChild("leaderstats"), Workspace}

    for _, place in ipairs(searchPlaces) do
        if place then
            for _, obj in ipairs(place:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                    if obj.Value == targetValue then
                        local parent = obj.Parent
                        if parent and parent:IsA("BasePart") or parent:FindFirstChild("Humanoid") then
                            CreateHighlight(parent, Color3.fromHex("#ffff00"), true) -- Amarelo temporário
                            found = found + 1
                        elseif parent and parent.Name:find("leaderstats") then
                            CreateHighlight(player.Character or player, Color3.fromHex("#00ff00"), true)
                            found = found + 1
                        end
                    end
                end
            end
        end
    end

    Rayfield:Notify({
        Title = "Busca Concluída",
        Content = found .. " valor(es) encontrado(s) com " .. targetValue,
        Duration = 6
    })

    -- Remove os highlights após 15 segundos
    task.delay(15, function()
        for _, hl in ipairs(tempHighlights) do pcall(function() hl:Destroy() end) end
        tempHighlights = {}
    end)
end

-- ==================== UI ====================
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local EspTab = Window:CreateTab("ESP", 4483362458)
local MoneyTab = Window:CreateTab("💰 Money", 6031097228)

MainTab:CreateSection("Murder Nice")

-- ESP Tab (igual antes)
EspTab:CreateSection("Visualizar Murderer")
EspTab:CreateToggle({Name = "Visualizar Murderer", CurrentValue = false, Callback = function(v) ESP.Murderer.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor do Murderer", Color = ESP.Murderer.Color, Callback = function(v) ESP.Murderer.Color = v end})

EspTab:CreateSection("Visualizar Xerife")
EspTab:CreateToggle({Name = "Visualizar Xerife", CurrentValue = false, Callback = function(v) ESP.Sheriff.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor do Xerife", Color = ESP.Sheriff.Color, Callback = function(v) ESP.Sheriff.Color = v end})

EspTab:CreateSection("Visualizar Players")
EspTab:CreateToggle({Name = "Visualizar Todos os Players", CurrentValue = false, Callback = function(v) ESP.Players.Enabled = v end})
EspTab:CreateColorPicker({Name = "Cor dos Players", Color = ESP.Players.Color, Callback = function(v) ESP.Players.Color = v end})

-- Money Tab
MoneyTab:CreateSection("Adicionar Dinheiro")

local MoneyInput = MoneyTab:CreateInput({
   Name = "Quantidade para Adicionar",
   PlaceholderText = "Ex: 5000",
   RemoveTextOnFocusLost = false,
   Callback = function() end,
})

MoneyTab:CreateButton({
   Name = "+ Adicionar Dinheiro",
   Callback = function()
      local amount = tonumber(MoneyInput.CurrentValue)
      if amount then AddMoney(amount) else Rayfield:Notify({Title = "Erro", Content = "Número inválido!", Duration = 3}) end
   end,
})

MoneyTab:CreateSection("Buscar Valor Atual")

local SearchInput = MoneyTab:CreateInput({
   Name = "Valor Atual das Suas Moedas",
   PlaceholderText = "Ex: 27",
   RemoveTextOnFocusLost = false,
   Callback = function() end,
})

MoneyTab:CreateButton({
   Name = "🔎 Procurar Valor",
   Callback = function()
      local value = tonumber(SearchInput.CurrentValue)
      if value then
         SearchForValue(value)
      else
         Rayfield:Notify({Title = "Erro", Content = "Digite um número válido!", Duration = 3})
      end
   end,
})

-- Loop ESP
RunService.RenderStepped:Connect(function()
    if ESP.Murderer.Enabled or ESP.Sheriff.Enabled or ESP.Players.Enabled then
        UpdateESP()
    else
        ClearHighlights()
    end
end)

Rayfield:Notify({Title = "Murder Nice", Content = "Buscador de valor adicionado!", Duration = 6})

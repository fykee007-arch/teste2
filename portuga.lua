local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Finish The Word - Helper",
   LoadingTitle = "Finish The Word",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local player = Players.LocalPlayer

-- ==================== VARIÁVEIS ====================
local UsedWords = {}
local HelperEnabled = false

-- Dicionário com +120 palavras em português
local Dictionary = {
    "Abacaxi", "Banana", "Cachorro", "Dinossauro", "Elefante", "Flamingo", "Girafa", 
    "Helicóptero", "Igreja", "Jacaré", "Ketchup", "Laranja", "Macaco", "Navio",
    "Ovelha", "Pássaro", "Queijo", "Rato", "Sapato", "Tartaruga", "Uva", "Vaca",
    "Xícara", "Yeti", "Zebra", "Espião", "Amigo", "Brasil", "Computador", "Dragão",
    "Escola", "Festa", "Gato", "Hospital", "Ilha", "Janela", "Livro", "Montanha",
    "Nuvem", "Oceano", "Piano", "Quadrado", "Relógio", "Sol", "Trem", "Universo",
    "Violão", "Whisky", "Xadrez", "Yogurte", "Zoológico", "Eletricidade", "Futebol",
    "Girassol", "Helicóptero", "Internet", "Jabuticaba", "Kanguru", "Luminária",
    "Maracujá", "Notebook", "Orquídea", "Pinguim", "Quarentena", "Rinoceronte",
    "Saxofone", "Telefone", "Umbigo", "Ventilador", "Xilofone", "Yakult", "Zangão",
    "Avestruz", "Borboleta", "Canguru", "Diamante", "Esmeralda", "Fósforo",
    "Golfinho", "Hipopótamo", "Iguana", "Jardim", "Koala", "Lâmpada", "Melancia",
    "Nariz", "Ostras", "Pavão", "Quebra-cabeça", "Rádio", "Supermercado",
    "Tubarão", "Ursinho", "Vampiro", "Whale", "Xampu", "Yoyo", "Zumbi",
    "Arco-íris", "Bicicleta", "Cachoeira", "Desenho", "Escada", "Foguete",
    "Garrafa", "Hambúrguer", "Inseto", "Janela", "Kiwi", "Lagoa", "Morango",
    "Notebook", "Ovo", "Papagaio", "Queijo", "Ratoeiro", "Sorvete", "Travesseiro",
    "Universidade", "Violino", "Xampu", "Yogurte", "Zoológico", "Abelha", "Barco",
    "Carro", "Dado", "Escola", "Faca", "Gelo", "Helicóptero", "Isca", "Jato",
    "Karatê", "Lua", "Manga", "Navalha", "Oito", "Pato", "Queijo", "Rato",
    "Sapo", "Tigre", "Uva", "Vento", "Xícara", "Yeti", "Zorro"
}

-- ==================== FUNÇÃO HELPER ====================
local function GetSuggestions(startLetter)
    local suggestions = {}
    startLetter = startLetter:lower()

    for _, word in ipairs(Dictionary) do
        if word:lower():sub(1,1) == startLetter and not UsedWords[word:lower()] then
            table.insert(suggestions, word)
            if #suggestions >= 5 then break end
        end
    end

    return suggestions
end

local function AddUsedWord(word)
    UsedWords[word:lower()] = true
end

-- ==================== UI ====================
local AjudaTab = Window:CreateTab("Ajuda", 4483362458)

AjudaTab:CreateSection("Word Helper")

local HelperToggle = AjudaTab:CreateToggle({
   Name = "Helper (Sugestões de Palavras)",
   CurrentValue = false,
   Callback = function(Value)
      HelperEnabled = Value
      if Value then
         Rayfield:Notify({Title = "Helper Ativado", Content = "O script agora sugere palavras!", Duration = 6})
      end
   end,
})

AjudaTab:CreateSection("Palavras Usadas")

local UsedList = AjudaTab:CreateParagraph({
    Title = "Palavras já usadas:",
    Content = "Nenhuma ainda..."
})

local function UpdateUsedList()
    local text = ""
    local count = 0
    for word, _ in pairs(UsedWords) do
        text = text .. "• " .. word .. "\n"
        count = count + 1
        if count >= 15 then 
            text = text .. "... e mais " .. (#UsedWords - 15) .. " palavras"
            break 
        end
    end
    if text == "" then text = "Nenhuma palavra usada ainda." end
    UsedList:Set({Title = "Palavras já usadas:", Content = text})
end

-- ==================== CHAT DETECTION ====================
Players.PlayerChatted:Connect(function(message, sender)
    if sender == player then
        local cleanWord = message:gsub("[%p%c]", ""):gsub("%s+", "")
        if #cleanWord > 2 then
            AddUsedWord(cleanWord)
            UpdateUsedList()
        end
    end
end)

Rayfield:Notify({
   Title = "Finish The Word Helper",
   Content = "Script carregado com +150 palavras no dicionário!",
   Duration = 8,
})

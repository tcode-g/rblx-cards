local Deck = {}
Deck.__index = Deck

local _defaultDeck = {
    "H2","H3","H4","H5","H6","H7","H8","H9","HJ","HQ","HK","HA",
    "D2","D3","D4","D5","D6","D7","D8","D9","DJ","DQ","DK","DA",
    "S2","S3","S4","S5","S6","S7","S8","S9","SJ","SQ","SK","SA",
    "C2","C3","C4","C5","C6","C7","C8","C9","CJ","CQ","CK","CA"
}


function Deck.create()
    local self = setmetatable({}, Deck)

    self:_blankSlate()

    return self
end

function Deck:getCard()
    local cardIndex = math.random(0, #self.Current - 1)
    local randomCard = self.Current[cardIndex]
    table.insert(self._previous, randomCard)
    table.remove(self.Current, cardIndex)
    return randomCard
end



function Deck:_findCard(cardIdentifier)
    -- maybe account for more types of the argument later
    local cardIndex = table.find(self.Current, cardIdentifier)
    if cardIndex then
        return cardIndex
    end
    local isCardUsed = table.find(self._previous, cardIdentifier)
    if isCardUsed then
        print("The card " .. tostring(cardIdentifier) .. " has already been used.")
    end
end
function Deck:_suitsCount()
    -- Hearts, Diamonds, Spades, Clubs
    local count = {0, 0, 0, 0}
    local suits = "HDSC"
    for _, card in pairs(self.Current) do
        local cardSuit = card:sub(0, 1)
        local foundSuit = suits:find(cardSuit)
        if foundSuit then
            count[foundSuit] += 1
        end
    end
    return count
end
function Deck:_blankSlate()
    self.Current = copy(_defaultDeck)
    self._previousCards = {}
end
function Deck:_cardCount()
    return #self.Current
end
function Deck:_canUse()
    return self:_cardCount() > 0
end


function copy(...)
    local args = {...}
    local deepCopy = args[2] == true
    assert(type(args[1] == "table", "Argument #1 must be type \"table\""))
    local tbl = args[1]

    local copy = {}
    for i, v in pairs(tbl) do
        if type(v) == "table" and deepCopy then
            copy[i] = tbl.copy(v)
        else
            copy[i] = v
        end
    end
    return copy
end

return Deck
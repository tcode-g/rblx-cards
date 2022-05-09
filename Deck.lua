local Deck = {}
Deck.__index = Deck

local _defaultDeck = {"H2","H3","H4","H5","H6","H7","H8","H9","HJ","HQ","HK","HA",
                    "D2","D3","D4","D5","D6","D7","D8","D9","DJ","DQ","DK","DA",
                    "S2","S3","S4","S5","S6","S7","S8","S9","SJ","SQ","SK","SA",
                    "C2","C3","C4","C5","C6","C7","C8","C9","CJ","CQ","CK","CA"}

function Deck.create()
    local self = setmetatable({}, Deck)

    self:blankSlate()

    return self
end



function Deck:blankSlate()
    self.Current = copy(_defaultDeck)
    self._previousCards = {}
end



function copy(...)
	local args = {...}
	local deepCopy = args[2] == true
	assert(type(args[1] == "table", "Argument #1 must be type \"tbl\""))
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
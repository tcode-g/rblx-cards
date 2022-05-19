local Http = game:GetService("HttpService")
local Replicated = game:GetService("ReplicatedStorage")
local Scripts = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Deck = require(Scripts.Deck)


-- GoFish
local Game = {}

function Game.create()
    local self = setmetatable({}, Game)
    
    self.Deck = Deck.create()
    self.Players = {}
    self.Hands = {}
    self.CardsDown = {}
    
    self._onFinished = nil
    self._lastRequest = nil
    
    self._Event = {}
    self._Game = "GoFish"

    return self
end

function Game:start()
    -- deal cards
    for i = 1, #self.Players do
        for c = 1, 7 do
            self:_assignCard(i)
        end
    end
end



--[[
create a server -> create a game
wait for players to be added



start the game if players >= 2
    send players the event name
    give the players their cards
]]


function Game:sendToPlayer(player, ...)
    if typeof(player) == "number" then
        player = self.Players[player]
    end
    self._Event:FireClient(player, ...)
end
function Game:getCard()
    -- this will change somehow
    return self.Deck:getCard()
end


function Game:_init()
    -- creates the event and the event listeners
    local event = Http:GenerateGUID(false)
    self._Event = Instance.new("RemoteEvent", Replicated)
    self._Event.Name = event
    -- tell the players to listen to this new event
    self._Manager:_listenEvent(self._Event)
    self._Event.OnServerEvent:Connect(function(player, ...)
        -- args: ask, gofish, givecards, putdown
        local args = {...}
        local cmd = args[1]
        if cmd == "ask" then
            -- 1st arg is player being asked, 2nd arg is the command, 3rd arg is the card
            -- **the player should be checked before sending
            self:sendToPlayer(args[2], cmd, args[3])
        elseif cmd == "gofish" then
            -- this tells the player that the card the person was asking they dont have
            local lrcmds = self._lastRequest[2]
            if lrcmds[1] == "ask" then
                self:sendToPlayer(args[2], cmd)
            end
        elseif cmd == "givecards" then
            -- this gives the cards to the other player to put down
            -- 1st arg is the player, 2nd arg is the cards that being given
            local lrcmds = self._lastRequest[2]
            if lrcmds[1] == "ask" then
                self:_removeCards(player, args[2])
                for i, card in pairs(args[2]) do
                    self:_assignCard(self._lastRequest[1], card)
                end
            end
        elseif cmd == "putdown" then
            -- puts down the cards given in the arguments

        elseif cmd == "pickcard" then
            -- gets a card from the deck
            self:_assignCard(player)
        end
        self._lastRequest = {player, args}
    end)
end

function Game:_removeCards(player, ...)
    local cards = {...}
    for i, card in pairs(cards) do
        table.remove(self.Hands[player], card)
    end
    return cards
end
function Game:_assignCard(player, card)
    if not card then
        card = self:getCard()
    end
    self:sendToPlayer(player, "getCard", card)
    -- player has to be a number
    table.insert(self.Hands[player], card)
end
function Game:_assignEndFunction(endfunc)
    self._onFinished = endfunc
end
function Game:_addPlayer(player)
    if table.find(Players:GetPlayers(), player) then
        table.insert(self.Players, player)
    end
end

function Game:_getPlayer(player)
    if typeof(player) == "number" then return player end
    local f = table.find(self.Players, player)
    if f then return f end

    print("player couldn't be found")
end




return Game
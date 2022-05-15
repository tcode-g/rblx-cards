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
    
    self._onFinished = nil
    
    self._Event = {}
    self._Game = "GoFish"

    return self
end

function Game:start()
    -- deal cards
    for i = 1, #self.Players do
        for c = 1, 7 do
            self:sendToPlayer(i, "getCard", self.Deck:getCard())
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

        elseif cmd == "givecards" then

        elseif cmd == "putdown" then
        
        elseif cmd == "pickcard" then
            
        end
    end)
end
function Game:_getCard()

end
function Game:_assignEndFunction(endfunc)
    self._onFinished = endfunc
end
function Game:_addPlayer(player)
    if table.find(Players:GetPlayers(), player) then
        table.insert(self.Players, player)
    end
end

return Game
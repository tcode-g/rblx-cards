local Players = game:GetService("Players")



local Game = {}

function Game.create()
    local self = setmetatable({}, Game)
    self.Players = {}
    self.Deck = {}
    
    self._Hands = {} -- what the players currently have in their hands
    self._gameType = "MAIN"
    self._event = nil
    self._server = {}

    return self
end


Game:communicatePlayer() -- 1st argument will be table of players, if table == true then its every player

Game:_onMessageReceived()

Game:_addPlayer()
Game:_onPlayerAdd()
Game:_onPlayerLeave()

Game:_onGameEnd()

Game:_endGameCheck()

-- default helper functions args(player, true) -> 2nd arg if in self.Players
Game:_isPlayer()

return Game
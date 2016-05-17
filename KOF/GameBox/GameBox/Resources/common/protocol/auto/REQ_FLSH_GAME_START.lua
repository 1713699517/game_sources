
require "common/RequestMessage"

-- [50230]开始游戏 -- 风林山火 

REQ_FLSH_GAME_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FLSH_GAME_START
	self:init(0 ,{ 50240,700 })
end)

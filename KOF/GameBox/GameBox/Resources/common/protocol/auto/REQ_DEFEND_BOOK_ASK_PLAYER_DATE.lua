
require "common/RequestMessage"

-- [21130]请求场景玩家数据 -- 活动-保卫经书 

REQ_DEFEND_BOOK_ASK_PLAYER_DATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_ASK_PLAYER_DATE
	self:init(0, nil)
end)

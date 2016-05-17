
require "common/RequestMessage"

-- (手动) -- [47290]请求购买面板 -- 藏宝阁系统 

REQ_TREASURE_BUY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_BUY
	self:init()
end)

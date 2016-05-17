
require "common/RequestMessage"

-- (手动) -- [47201]请求面板 -- 藏宝阁系统 

REQ_TREASURE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_REQUEST
	self:init()
end)

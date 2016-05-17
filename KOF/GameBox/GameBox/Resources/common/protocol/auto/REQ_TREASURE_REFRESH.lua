
require "common/RequestMessage"

-- (手动) -- [47275]请求刷新 -- 藏宝阁系统 

REQ_TREASURE_REFRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_REFRESH
	self:init()
end)


require "common/RequestMessage"

-- (手动) -- [24870]请求我的个人排行数据 -- 排行榜 

REQ_TOP_SELF_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TOP_SELF_ASK
	self:init()
end)

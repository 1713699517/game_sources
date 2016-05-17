
require "common/RequestMessage"

-- [40550]请求天宫之战积分数据 -- 天宫之战 

REQ_SKYWAR_ASK_SCORE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_ASK_SCORE
	self:init(0, nil)
end)

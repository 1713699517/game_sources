
require "common/RequestMessage"

-- [54815]请求积分榜数据 -- 格斗之王 

REQ_WRESTLE_SCORE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_SCORE
	self:init(0, nil)
end)

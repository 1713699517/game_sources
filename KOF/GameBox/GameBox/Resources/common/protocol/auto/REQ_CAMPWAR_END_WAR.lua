
require "common/RequestMessage"

-- [45750]战斗结束 -- 活动-阵营战 

REQ_CAMPWAR_END_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_END_WAR
	self:init(0, nil)
end)

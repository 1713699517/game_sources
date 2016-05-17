
require "common/RequestMessage"

-- [45720]开始匹配战斗 -- 活动-阵营战 

REQ_CAMPWAR_START_MACHING = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_START_MACHING
	self:init(0, nil)
end)

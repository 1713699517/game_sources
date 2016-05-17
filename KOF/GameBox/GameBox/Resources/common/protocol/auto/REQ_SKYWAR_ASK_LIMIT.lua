
require "common/RequestMessage"

-- [40510]查询是否可参与天宫之战 -- 天宫之战 

REQ_SKYWAR_ASK_LIMIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_ASK_LIMIT
	self:init(0, nil)
end)

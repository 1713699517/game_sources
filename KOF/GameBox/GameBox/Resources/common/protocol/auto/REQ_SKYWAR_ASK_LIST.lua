
require "common/RequestMessage"

-- [40530]请求查看攻守列表(上阵) -- 天宫之战 

REQ_SKYWAR_ASK_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_ASK_LIST
	self:init(0, nil)
end)

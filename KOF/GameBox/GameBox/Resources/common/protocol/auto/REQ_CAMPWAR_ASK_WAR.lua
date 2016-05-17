
require "common/RequestMessage"

-- [45610]请求阵营战界面 -- 活动-阵营战 

REQ_CAMPWAR_ASK_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_ASK_WAR
	self:init(0, nil)
end)

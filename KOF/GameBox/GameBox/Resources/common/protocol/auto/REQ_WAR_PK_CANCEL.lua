
require "common/RequestMessage"

-- [6055]取消邀请 -- 战斗 

REQ_WAR_PK_CANCEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_PK_CANCEL
	self:init(0, nil)
end)

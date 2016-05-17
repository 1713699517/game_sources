
require "common/RequestMessage"

-- [41510]创建年兽 -- 年兽 

REQ_NIANSHOU_CREAT_NIANSHOU = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NIANSHOU_CREAT_NIANSHOU
	self:init(0, nil)
end)

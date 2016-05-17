
require "common/RequestMessage"

-- [54830]离开格斗之王面板 -- 格斗之王 

REQ_WRESTLE_DROP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_DROP
	self:init(0, nil)
end)

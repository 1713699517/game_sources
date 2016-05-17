
require "common/RequestMessage"

-- [54803]格斗之王报名 -- 格斗之王 

REQ_WRESTLE_APPLY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_APPLY
	self:init(0, nil)
end)


require "common/AcknowledgementMessage"

-- [2561]镶嵌宝石成功 -- 物品/打造/强化 

ACK_MAKE_PEARL_INSET_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_PEARL_INSET_OK
	self:init()
end)

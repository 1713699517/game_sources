
require "common/AcknowledgementMessage"

-- [2582]法宝拆分成功 -- 物品/打造/强化 

ACK_MAKE_MAGIC_PART_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_MAGIC_PART_OK
	self:init()
end)

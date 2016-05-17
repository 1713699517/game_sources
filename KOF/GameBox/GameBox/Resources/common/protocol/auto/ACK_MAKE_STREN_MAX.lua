
require "common/AcknowledgementMessage"

-- [2519]不可强化或已达最高级 -- 物品/打造/强化 

ACK_MAKE_STREN_MAX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_STREN_MAX
	self:init()
end)

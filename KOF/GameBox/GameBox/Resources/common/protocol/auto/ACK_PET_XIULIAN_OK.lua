
require "common/AcknowledgementMessage"

-- [22885]魔宠修炼成功返回 -- 宠物 

ACK_PET_XIULIAN_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_XIULIAN_OK
	self:init()
end)

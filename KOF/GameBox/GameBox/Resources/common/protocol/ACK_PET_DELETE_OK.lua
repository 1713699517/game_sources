
require "common/AcknowledgementMessage"

-- [22880]删除宠物成功 -- 宠物 

ACK_PET_DELETE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_DELETE_OK
	self:init()
end)

-- {宠物栏索引}
function ACK_PET_DELETE_OK.getIdx(self)
	return self.idx
end

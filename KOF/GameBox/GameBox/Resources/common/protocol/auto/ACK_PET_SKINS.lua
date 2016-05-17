
require "common/AcknowledgementMessage"

-- [22827]皮肤信息块 -- 宠物 

ACK_PET_SKINS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_SKINS
	self:init()
end)

function ACK_PET_SKINS.deserialize(self, reader)
	self.skin_id = reader:readInt16Unsigned() -- {皮肤id}
end

-- {皮肤id}
function ACK_PET_SKINS.getSkinId(self)
	return self.skin_id
end

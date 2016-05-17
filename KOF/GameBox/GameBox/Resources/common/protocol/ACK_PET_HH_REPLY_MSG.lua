
require "common/AcknowledgementMessage"

-- [23010]幻化界面返回 -- 宠物 

ACK_PET_HH_REPLY_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_HH_REPLY_MSG
	self:init()
end)

function ACK_PET_HH_REPLY_MSG.deserialize(self, reader)
	self.count   = reader:readInt8Unsigned()  -- {皮肤数量}
	self.skin_id = reader:readInt16Unsigned() -- {使用中的皮肤id}
	--self.skin_id = reader:readInt16Unsigned() -- {皮肤id}
    self.MsgSkin = {}
    local icount  = 1
    while icount <= self.count do
        self.MsgSkin[icount] = reader:readInt16Unsigned()
        icount = icount + 1
    end
end

-- {皮肤数量}
function ACK_PET_HH_REPLY_MSG.getCount(self)
	return self.count
end
-- {使用中的皮肤id}
function ACK_PET_HH_REPLY_MSG.getSkinId(self)
	return self.skin_id
end

-- {皮肤id}
function ACK_PET_HH_REPLY_MSG.getMsgSkin(self)
	return self.MsgSkin
end

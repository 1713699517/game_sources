
require "common/AcknowledgementMessage"

-- [28050]布阵伙伴信息块 -- 布阵 

ACK_ARRAY_ROLE_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARRAY_ROLE_INFO
	self:init()
end)

function ACK_ARRAY_ROLE_INFO.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {1:玩家,2:伙伴}
	self.id = reader:readInt16Unsigned() -- {伙伴ID/玩家UID}
	self.position_idx = reader:readInt8Unsigned() -- {阵位}
	self.lv = reader:readInt16Unsigned() -- {等级}
end

-- {1:玩家,2:伙伴}
function ACK_ARRAY_ROLE_INFO.getType(self)
	return self.type
end

-- {伙伴ID/玩家UID}
function ACK_ARRAY_ROLE_INFO.getId(self)
	return self.id
end

-- {阵位}
function ACK_ARRAY_ROLE_INFO.getPositionIdx(self)
	return self.position_idx
end

-- {等级}
function ACK_ARRAY_ROLE_INFO.getLv(self)
	return self.lv
end

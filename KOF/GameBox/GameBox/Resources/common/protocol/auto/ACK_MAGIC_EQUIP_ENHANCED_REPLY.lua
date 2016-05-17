
require "common/AcknowledgementMessage"

-- [52240]强化返回 -- 神器 

ACK_MAGIC_EQUIP_ENHANCED_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_ENHANCED_REPLY
	self:init()
end)

function ACK_MAGIC_EQUIP_ENHANCED_REPLY.deserialize(self, reader)
	self.flag = reader:readInt8Unsigned() -- {是否成功(1为成功强化，0为失败)}
	self.type_c = reader:readInt8Unsigned() -- {1背包2装备栏}
	self.id = reader:readInt32Unsigned() -- {主将0|武将ID}
	self.idx = reader:readInt16Unsigned() -- {神器的idx}
end

-- {是否成功(1为成功强化，0为失败)}
function ACK_MAGIC_EQUIP_ENHANCED_REPLY.getFlag(self)
	return self.flag
end

-- {1背包2装备栏}
function ACK_MAGIC_EQUIP_ENHANCED_REPLY.getTypeC(self)
	return self.type_c
end

-- {主将0|武将ID}
function ACK_MAGIC_EQUIP_ENHANCED_REPLY.getId(self)
	return self.id
end

-- {神器的idx}
function ACK_MAGIC_EQUIP_ENHANCED_REPLY.getIdx(self)
	return self.idx
end

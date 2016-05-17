
require "common/AcknowledgementMessage"

-- [52220]神器强化 -- 神器 

ACK_MAGIC_EQUIP_ENHANCED = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_ENHANCED
	self:init()
end)

function ACK_MAGIC_EQUIP_ENHANCED.deserialize(self, reader)
	self.magic_id = reader:readInt32Unsigned() -- {神器id}
	self.signer = reader:readInt8Unsigned() -- {勋章}
	self.bless = reader:readInt8Unsigned() -- {保护石}
	self.protection = reader:readInt8Unsigned() -- {护符}
end

-- {神器id}
function ACK_MAGIC_EQUIP_ENHANCED.getMagicId(self)
	return self.magic_id
end

-- {勋章}
function ACK_MAGIC_EQUIP_ENHANCED.getSigner(self)
	return self.signer
end

-- {保护石}
function ACK_MAGIC_EQUIP_ENHANCED.getBless(self)
	return self.bless
end

-- {护符}
function ACK_MAGIC_EQUIP_ENHANCED.getProtection(self)
	return self.protection
end

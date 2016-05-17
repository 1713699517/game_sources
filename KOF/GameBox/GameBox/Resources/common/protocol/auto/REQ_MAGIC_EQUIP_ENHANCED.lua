
require "common/RequestMessage"

-- [52220]神器强化 -- 神器 

REQ_MAGIC_EQUIP_ENHANCED = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_ENHANCED
	self:init(0, nil)
end)

function REQ_MAGIC_EQUIP_ENHANCED.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1强化2一键强化}
	writer:writeInt8Unsigned(self.type_c)  -- {1背包，2武将}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.magic_idx)  -- {神器idx}
	writer:writeInt16Unsigned(self.bless_id)  -- {祝福石id（0为不使用祝福石,其他为对应的祝福石级别）}
	writer:writeInt16Unsigned(self.protection_id)  -- {护符（0为不使用护符,1为使用相对应得护符，七级以下（包括七级）默认不使用）}
end

function REQ_MAGIC_EQUIP_ENHANCED.setArguments(self,type,type_c,id,magic_idx,bless_id,protection_id)
	self.type = type  -- {1强化2一键强化}
	self.type_c = type_c  -- {1背包，2武将}
	self.id = id  -- {主将0|武将ID}
	self.magic_idx = magic_idx  -- {神器idx}
	self.bless_id = bless_id  -- {祝福石id（0为不使用祝福石,其他为对应的祝福石级别）}
	self.protection_id = protection_id  -- {护符（0为不使用护符,1为使用相对应得护符，七级以下（包括七级）默认不使用）}
end

-- {1强化2一键强化}
function REQ_MAGIC_EQUIP_ENHANCED.setType(self, type)
	self.type = type
end
function REQ_MAGIC_EQUIP_ENHANCED.getType(self)
	return self.type
end

-- {1背包，2武将}
function REQ_MAGIC_EQUIP_ENHANCED.setTypeC(self, type_c)
	self.type_c = type_c
end
function REQ_MAGIC_EQUIP_ENHANCED.getTypeC(self)
	return self.type_c
end

-- {主将0|武将ID}
function REQ_MAGIC_EQUIP_ENHANCED.setId(self, id)
	self.id = id
end
function REQ_MAGIC_EQUIP_ENHANCED.getId(self)
	return self.id
end

-- {神器idx}
function REQ_MAGIC_EQUIP_ENHANCED.setMagicIdx(self, magic_idx)
	self.magic_idx = magic_idx
end
function REQ_MAGIC_EQUIP_ENHANCED.getMagicIdx(self)
	return self.magic_idx
end

-- {祝福石id（0为不使用祝福石,其他为对应的祝福石级别）}
function REQ_MAGIC_EQUIP_ENHANCED.setBlessId(self, bless_id)
	self.bless_id = bless_id
end
function REQ_MAGIC_EQUIP_ENHANCED.getBlessId(self)
	return self.bless_id
end

-- {护符（0为不使用护符,1为使用相对应得护符，七级以下（包括七级）默认不使用）}
function REQ_MAGIC_EQUIP_ENHANCED.setProtectionId(self, protection_id)
	self.protection_id = protection_id
end
function REQ_MAGIC_EQUIP_ENHANCED.getProtectionId(self)
	return self.protection_id
end

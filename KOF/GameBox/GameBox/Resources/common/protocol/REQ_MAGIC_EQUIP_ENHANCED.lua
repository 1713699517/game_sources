
require "common/RequestMessage"

-- [52220]神器强化 -- 神器 

REQ_MAGIC_EQUIP_ENHANCED = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_ENHANCED
	self:init()
end)

function REQ_MAGIC_EQUIP_ENHANCED.serialize(self, writer)
	writer:writeInt32Unsigned(self.magic_id)  -- {神器id}
	writer:writeInt32Unsigned(self.magic_idx)  -- {神器idx}
	writer:writeInt16Unsigned(self.signer)  -- {勋章}
	writer:writeInt16Unsigned(self.bless)  -- {保护石}
	writer:writeInt16Unsigned(self.protection)  -- {护符}
end

function REQ_MAGIC_EQUIP_ENHANCED.setArguments(self,magic_id,magic_idx,signer,bless,protection)
	self.magic_id = magic_id  -- {神器id}
	self.magic_idx = magic_idx  -- {神器idx}
	self.signer = signer  -- {勋章}
	self.bless = bless  -- {保护石}
	self.protection = protection  -- {护符}
end

-- {神器id}
function REQ_MAGIC_EQUIP_ENHANCED.setMagicId(self, magic_id)
	self.magic_id = magic_id
end
function REQ_MAGIC_EQUIP_ENHANCED.getMagicId(self)
	return self.magic_id
end

-- {神器idx}
function REQ_MAGIC_EQUIP_ENHANCED.setMagicIdx(self, magic_idx)
	self.magic_idx = magic_idx
end
function REQ_MAGIC_EQUIP_ENHANCED.getMagicIdx(self)
	return self.magic_idx
end

-- {勋章}
function REQ_MAGIC_EQUIP_ENHANCED.setSigner(self, signer)
	self.signer = signer
end
function REQ_MAGIC_EQUIP_ENHANCED.getSigner(self)
	return self.signer
end

-- {保护石}
function REQ_MAGIC_EQUIP_ENHANCED.setBless(self, bless)
	self.bless = bless
end
function REQ_MAGIC_EQUIP_ENHANCED.getBless(self)
	return self.bless
end

-- {护符}
function REQ_MAGIC_EQUIP_ENHANCED.setProtection(self, protection)
	self.protection = protection
end
function REQ_MAGIC_EQUIP_ENHANCED.getProtection(self)
	return self.protection
end

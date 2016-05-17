
require "common/RequestMessage"

-- [52230]神器进阶 -- 神器 

REQ_MAGIC_EQUIP_ADVANCE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_ADVANCE
	self:init(0, nil)
end)

function REQ_MAGIC_EQUIP_ADVANCE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包 ，2武将}
	writer:writeInt32Unsigned(self.id)  -- {主将0 | 武将id}
	writer:writeInt16Unsigned(self.idx)  -- {神器idx}
	writer:writeInt16Unsigned(self.holy_water_id)  -- {圣水id}
end

function REQ_MAGIC_EQUIP_ADVANCE.setArguments(self,type,id,idx,holy_water_id)
	self.type = type  -- {1背包 ，2武将}
	self.id = id  -- {主将0 | 武将id}
	self.idx = idx  -- {神器idx}
	self.holy_water_id = holy_water_id  -- {圣水id}
end

-- {1背包 ，2武将}
function REQ_MAGIC_EQUIP_ADVANCE.setType(self, type)
	self.type = type
end
function REQ_MAGIC_EQUIP_ADVANCE.getType(self)
	return self.type
end

-- {主将0 | 武将id}
function REQ_MAGIC_EQUIP_ADVANCE.setId(self, id)
	self.id = id
end
function REQ_MAGIC_EQUIP_ADVANCE.getId(self)
	return self.id
end

-- {神器idx}
function REQ_MAGIC_EQUIP_ADVANCE.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAGIC_EQUIP_ADVANCE.getIdx(self)
	return self.idx
end

-- {圣水id}
function REQ_MAGIC_EQUIP_ADVANCE.setHolyWaterId(self, holy_water_id)
	self.holy_water_id = holy_water_id
end
function REQ_MAGIC_EQUIP_ADVANCE.getHolyWaterId(self)
	return self.holy_water_id
end

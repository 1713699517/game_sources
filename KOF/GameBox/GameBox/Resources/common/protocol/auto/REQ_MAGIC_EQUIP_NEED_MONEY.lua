
require "common/RequestMessage"

-- [52250]神器强化所需要钱数 -- 神器 

REQ_MAGIC_EQUIP_NEED_MONEY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_NEED_MONEY
	self:init(0, nil)
end)

function REQ_MAGIC_EQUIP_NEED_MONEY.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {强化类型（1为强化，2为一键强化）}
	writer:writeInt8Unsigned(self.type_c)  -- {1背包 ，2武将}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {神器idx}
end

function REQ_MAGIC_EQUIP_NEED_MONEY.setArguments(self,type,type_c,id,idx)
	self.type = type  -- {强化类型（1为强化，2为一键强化）}
	self.type_c = type_c  -- {1背包 ，2武将}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {神器idx}
end

-- {强化类型（1为强化，2为一键强化）}
function REQ_MAGIC_EQUIP_NEED_MONEY.setType(self, type)
	self.type = type
end
function REQ_MAGIC_EQUIP_NEED_MONEY.getType(self)
	return self.type
end

-- {1背包 ，2武将}
function REQ_MAGIC_EQUIP_NEED_MONEY.setTypeC(self, type_c)
	self.type_c = type_c
end
function REQ_MAGIC_EQUIP_NEED_MONEY.getTypeC(self)
	return self.type_c
end

-- {主将0|武将ID}
function REQ_MAGIC_EQUIP_NEED_MONEY.setId(self, id)
	self.id = id
end
function REQ_MAGIC_EQUIP_NEED_MONEY.getId(self)
	return self.id
end

-- {神器idx}
function REQ_MAGIC_EQUIP_NEED_MONEY.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAGIC_EQUIP_NEED_MONEY.getIdx(self)
	return self.idx
end


require "common/RequestMessage"

-- [2515]装备强化（废除） -- 物品/打造/强化 

REQ_MAKE_STRENGTHEN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_STRENGTHEN
	self:init(1 ,{ 2518,2519,2520,700 })
end)

function REQ_MAKE_STRENGTHEN.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:背包2:装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {打造装备的idx}
	writer:writeBoolean(self.discount)  -- {是否打折扣}
	writer:writeBoolean(self.dou)  -- {是否双倍强化}
	writer:writeInt8Unsigned(self.cost_type)  -- {0:普通强化|1:金元强化}
end

function REQ_MAKE_STRENGTHEN.setArguments(self,type,id,idx,discount,dou,cost_type)
	self.type = type  -- {1:背包2:装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {打造装备的idx}
	self.discount = discount  -- {是否打折扣}
	self.dou = dou  -- {是否双倍强化}
	self.cost_type = cost_type  -- {0:普通强化|1:金元强化}
end

-- {1:背包2:装备栏}
function REQ_MAKE_STRENGTHEN.setType(self, type)
	self.type = type
end
function REQ_MAKE_STRENGTHEN.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_STRENGTHEN.setId(self, id)
	self.id = id
end
function REQ_MAKE_STRENGTHEN.getId(self)
	return self.id
end

-- {打造装备的idx}
function REQ_MAKE_STRENGTHEN.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_STRENGTHEN.getIdx(self)
	return self.idx
end

-- {是否打折扣}
function REQ_MAKE_STRENGTHEN.setDiscount(self, discount)
	self.discount = discount
end
function REQ_MAKE_STRENGTHEN.getDiscount(self)
	return self.discount
end

-- {是否双倍强化}
function REQ_MAKE_STRENGTHEN.setDou(self, dou)
	self.dou = dou
end
function REQ_MAKE_STRENGTHEN.getDou(self)
	return self.dou
end

-- {0:普通强化|1:金元强化}
function REQ_MAKE_STRENGTHEN.setCostType(self, cost_type)
	self.cost_type = cost_type
end
function REQ_MAKE_STRENGTHEN.getCostType(self)
	return self.cost_type
end

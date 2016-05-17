
require "common/RequestMessage"

-- [2513]强化（new） -- 物品/打造/强化 

REQ_MAKE_KEY_STREN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_KEY_STREN
	self:init(1 ,{ 2518,2519,2520,700 })
end)

function REQ_MAKE_KEY_STREN.serialize(self, writer)
	writer:writeInt8Unsigned(self.stren_type)  -- {1:一键强化,2:普通强化}
	writer:writeInt8Unsigned(self.type)  -- {1:背包2:装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {打造装备的idx}
	writer:writeBoolean(self.discount)  -- {是否打折扣}
	writer:writeBoolean(self.dou)  -- {是否双倍强化}
	writer:writeInt8Unsigned(self.cost_type)  -- {0:普通强化|1:金元强化}
end

function REQ_MAKE_KEY_STREN.setArguments(self,stren_type,type,id,idx,discount,dou,cost_type)
	self.stren_type = stren_type  -- {1:一键强化,2:普通强化}
	self.type = type  -- {1:背包2:装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {打造装备的idx}
	self.discount = discount  -- {是否打折扣}
	self.dou = dou  -- {是否双倍强化}
	self.cost_type = cost_type  -- {0:普通强化|1:金元强化}
end

-- {1:一键强化,2:普通强化}
function REQ_MAKE_KEY_STREN.setStrenType(self, stren_type)
	self.stren_type = stren_type
end
function REQ_MAKE_KEY_STREN.getStrenType(self)
	return self.stren_type
end

-- {1:背包2:装备栏}
function REQ_MAKE_KEY_STREN.setType(self, type)
	self.type = type
end
function REQ_MAKE_KEY_STREN.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_KEY_STREN.setId(self, id)
	self.id = id
end
function REQ_MAKE_KEY_STREN.getId(self)
	return self.id
end

-- {打造装备的idx}
function REQ_MAKE_KEY_STREN.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_KEY_STREN.getIdx(self)
	return self.idx
end

-- {是否打折扣}
function REQ_MAKE_KEY_STREN.setDiscount(self, discount)
	self.discount = discount
end
function REQ_MAKE_KEY_STREN.getDiscount(self)
	return self.discount
end

-- {是否双倍强化}
function REQ_MAKE_KEY_STREN.setDou(self, dou)
	self.dou = dou
end
function REQ_MAKE_KEY_STREN.getDou(self)
	return self.dou
end

-- {0:普通强化|1:金元强化}
function REQ_MAKE_KEY_STREN.setCostType(self, cost_type)
	self.cost_type = cost_type
end
function REQ_MAKE_KEY_STREN.getCostType(self)
	return self.cost_type
end

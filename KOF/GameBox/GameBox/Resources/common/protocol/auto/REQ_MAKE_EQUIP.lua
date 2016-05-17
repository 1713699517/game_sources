
require "common/RequestMessage"

-- [2510]装备首饰打造 -- 物品/打造/强化 

REQ_MAKE_EQUIP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_EQUIP
	self:init(0, nil)
end)

function REQ_MAKE_EQUIP.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1背包2装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {打造装备的idx}
	writer:writeInt32Unsigned(self.gid)  -- {希望打造的物品id}
end

function REQ_MAKE_EQUIP.setArguments(self,type,id,idx,gid)
	self.type = type  -- {1背包2装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {打造装备的idx}
	self.gid = gid  -- {希望打造的物品id}
end

-- {1背包2装备栏}
function REQ_MAKE_EQUIP.setType(self, type)
	self.type = type
end
function REQ_MAKE_EQUIP.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_EQUIP.setId(self, id)
	self.id = id
end
function REQ_MAKE_EQUIP.getId(self)
	return self.id
end

-- {打造装备的idx}
function REQ_MAKE_EQUIP.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_EQUIP.getIdx(self)
	return self.idx
end

-- {希望打造的物品id}
function REQ_MAKE_EQUIP.setGid(self, gid)
	self.gid = gid
end
function REQ_MAKE_EQUIP.getGid(self)
	return self.gid
end

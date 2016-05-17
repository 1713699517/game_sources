
require "common/RequestMessage"

-- [2522]法宝升阶 -- 物品/打造/强化 

REQ_MAKE_MAGIC_UPGRADE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_MAGIC_UPGRADE
	self:init(0, nil)
end)

function REQ_MAKE_MAGIC_UPGRADE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:背包2:装备栏}
	writer:writeInt32Unsigned(self.id)  -- {主将0|武将ID}
	writer:writeInt16Unsigned(self.idx)  -- {物品索引}
end

function REQ_MAKE_MAGIC_UPGRADE.setArguments(self,type,id,idx)
	self.type = type  -- {1:背包2:装备栏}
	self.id = id  -- {主将0|武将ID}
	self.idx = idx  -- {物品索引}
end

-- {1:背包2:装备栏}
function REQ_MAKE_MAGIC_UPGRADE.setType(self, type)
	self.type = type
end
function REQ_MAKE_MAGIC_UPGRADE.getType(self)
	return self.type
end

-- {主将0|武将ID}
function REQ_MAKE_MAGIC_UPGRADE.setId(self, id)
	self.id = id
end
function REQ_MAKE_MAGIC_UPGRADE.getId(self)
	return self.id
end

-- {物品索引}
function REQ_MAKE_MAGIC_UPGRADE.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_MAGIC_UPGRADE.getIdx(self)
	return self.idx
end

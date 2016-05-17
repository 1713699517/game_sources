
require "common/RequestMessage"

-- [2540]是否保留洗练数据 -- 物品/打造/强化 

REQ_MAKE_WASH_SAVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_WASH_SAVE
	self:init(0, nil)
end)

function REQ_MAKE_WASH_SAVE.serialize(self, writer)
	writer:writeBoolean(self.save)  -- {true:保留|false:不保留}
	writer:writeInt16Unsigned(self.idx)  -- {属性索引|如是武器技发0}
end

function REQ_MAKE_WASH_SAVE.setArguments(self,save,idx)
	self.save = save  -- {true:保留|false:不保留}
	self.idx = idx  -- {属性索引|如是武器技发0}
end

-- {true:保留|false:不保留}
function REQ_MAKE_WASH_SAVE.setSave(self, save)
	self.save = save
end
function REQ_MAKE_WASH_SAVE.getSave(self)
	return self.save
end

-- {属性索引|如是武器技发0}
function REQ_MAKE_WASH_SAVE.setIdx(self, idx)
	self.idx = idx
end
function REQ_MAKE_WASH_SAVE.getIdx(self)
	return self.idx
end

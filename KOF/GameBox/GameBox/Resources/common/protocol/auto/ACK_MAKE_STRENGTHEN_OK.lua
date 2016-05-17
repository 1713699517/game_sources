
require "common/AcknowledgementMessage"

-- [2520]装备强化成功 -- 物品/打造/强化 

ACK_MAKE_STRENGTHEN_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_STRENGTHEN_OK
	self:init()
end)

function ACK_MAKE_STRENGTHEN_OK.deserialize(self, reader)
	self.falg = reader:readInt8Unsigned() -- {1: 成功0：失败}
	self.type = reader:readInt8Unsigned() -- {1背包2装备栏}
	self.id = reader:readInt32Unsigned() -- {主将0|武将ID}
	self.idx = reader:readInt8Unsigned() -- {强化后的物品idx}
end

-- {1: 成功0：失败}
function ACK_MAKE_STRENGTHEN_OK.getFalg(self)
	return self.falg
end

-- {1背包2装备栏}
function ACK_MAKE_STRENGTHEN_OK.getType(self)
	return self.type
end

-- {主将0|武将ID}
function ACK_MAKE_STRENGTHEN_OK.getId(self)
	return self.id
end

-- {强化后的物品idx}
function ACK_MAKE_STRENGTHEN_OK.getIdx(self)
	return self.idx
end

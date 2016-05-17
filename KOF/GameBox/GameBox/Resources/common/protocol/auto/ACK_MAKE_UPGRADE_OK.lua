
require "common/AcknowledgementMessage"

-- [2525]法宝升阶成功 -- 物品/打造/强化 

ACK_MAKE_UPGRADE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_UPGRADE_OK
	self:init()
end)

function ACK_MAKE_UPGRADE_OK.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {1背包2装备栏}
	self.id = reader:readInt32Unsigned() -- {主将0|武将ID}
	self.idx = reader:readInt16Unsigned() -- {物品的idx}
end

-- {1背包2装备栏}
function ACK_MAKE_UPGRADE_OK.getType(self)
	return self.type
end

-- {主将0|武将ID}
function ACK_MAKE_UPGRADE_OK.getId(self)
	return self.id
end

-- {物品的idx}
function ACK_MAKE_UPGRADE_OK.getIdx(self)
	return self.idx
end

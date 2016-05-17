
require "common/AcknowledgementMessage"

-- [2334]次数物品日志数据块 -- 物品/背包 

ACK_GOODS_TIMES_XXX2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_TIMES_XXX2
	self:init()
end)

function ACK_GOODS_TIMES_XXX2.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {使用者uid}
	self.name = reader:readString() -- {使用者名字}
	self.name_color = reader:readInt8Unsigned() -- {使用者名字颜色}
	self.gid_use = reader:readInt32Unsigned() -- {使用的物品ID}
	self.count_use = reader:readInt16Unsigned() -- {使用的物品数量}
	self.gid_get = reader:readInt32Unsigned() -- {获得的物品ID}
	self.count_get = reader:readInt16Unsigned() -- {获得的物品数量}
	self.seconds = reader:readInt32Unsigned() -- {使用时间戳}
end

-- {使用者uid}
function ACK_GOODS_TIMES_XXX2.getUid(self)
	return self.uid
end

-- {使用者名字}
function ACK_GOODS_TIMES_XXX2.getName(self)
	return self.name
end

-- {使用者名字颜色}
function ACK_GOODS_TIMES_XXX2.getNameColor(self)
	return self.name_color
end

-- {使用的物品ID}
function ACK_GOODS_TIMES_XXX2.getGidUse(self)
	return self.gid_use
end

-- {使用的物品数量}
function ACK_GOODS_TIMES_XXX2.getCountUse(self)
	return self.count_use
end

-- {获得的物品ID}
function ACK_GOODS_TIMES_XXX2.getGidGet(self)
	return self.gid_get
end

-- {获得的物品数量}
function ACK_GOODS_TIMES_XXX2.getCountGet(self)
	return self.count_get
end

-- {使用时间戳}
function ACK_GOODS_TIMES_XXX2.getSeconds(self)
	return self.seconds
end

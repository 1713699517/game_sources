
require "common/AcknowledgementMessage"

-- [52315]材料信息块 -- 神器 

ACK_MAGIC_EQUIP_MSG_ITEM_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_MSG_ITEM_XXX
	self:init()
end)

function ACK_MAGIC_EQUIP_MSG_ITEM_XXX.deserialize(self, reader)
	self.item_id = reader:readInt16Unsigned() -- {材料ID}
	self.count = reader:readInt16Unsigned() -- {材料数量}
end

-- {材料ID}
function ACK_MAGIC_EQUIP_MSG_ITEM_XXX.getItemId(self)
	return self.item_id
end

-- {材料数量}
function ACK_MAGIC_EQUIP_MSG_ITEM_XXX.getCount(self)
	return self.count
end

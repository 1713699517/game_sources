
require "common/AcknowledgementMessage"

-- [2003]插槽信息块 -- 物品/背包 

ACK_GOODS_XXX3 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_XXX3
	self:init()
end)

function ACK_GOODS_XXX3.deserialize(self, reader)
    self.slot_flag     = reader: readBoolean()
    print("插槽信息块是否有值:"..type(self.slot_flag))
    if self.slot_flag then
        self.slot_pearl_id = reader: readInt16Unsigned();
        self.count         = reader: readInt16Unsigned();
        print("插槽信息块 ID:"..self.slot_pearl_id.."数量:"..self.count)
        --msggroup = msg.readXXXGroup();  -- {插槽属性块(2003 P_GOODS_XXX5)}       
        local icount = 1
        self.msg_group = {}
        while icount <= self.count do
            print("第 "..icount.." 个插槽属性:")
            local tempData = ACK_GOODS_XXX5()
            tempData :deserialize( reader)
            self.msg_group[icount] = tempData
            icount = icount + 1
        end
    end
end

-- {插槽状态（true:有|false:空）}
function ACK_GOODS_XXX3.getSlotFlag(self)
	return self.slot_flag
end

-- {插槽镶嵌的灵珠ID}
function ACK_GOODS_XXX3.getSlotPearlId(self)
	return self.slot_pearl_id
end

-- {插槽属性数量}
function ACK_GOODS_XXX3.getCount(self)
	return self.count
end

-- {插槽属性块2005}
function ACK_GOODS_XXX3.getMsgGroup(self)
	return self.msg_group
end

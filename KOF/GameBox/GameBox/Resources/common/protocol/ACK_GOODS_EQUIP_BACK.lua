
require "common/AcknowledgementMessage"

-- [2242]角色装备信息返回 -- 物品/背包 

ACK_GOODS_EQUIP_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_EQUIP_BACK
	self:init()
end)


function ACK_GOODS_EQUIP_BACK.deserialize(self, reader)
	self.uid         = reader:readInt32Unsigned() -- {玩家UID}
	self.partner     = reader:readInt32Unsigned() -- {主将:0|武将id}
	self.count       = reader:readInt16Unsigned() -- {装备数量}
    
	--self.msg_group = reader:readXXXGroup()      -- {物品信息块(2001 P_GOODS_XXX1)}
    local icount = 1
    self.msg_group = {}
    while icount <= self.count do
        print("第 "..icount.." 个物品:")
        local tempData = ACK_GOODS_XXX1()
        tempData :deserialize( reader)
        self.msg_group[icount] = tempData
        icount = icount + 1
    end
end


-- {玩家uid}
function ACK_GOODS_EQUIP_BACK.getUid(self)
	return self.uid
end

-- {主将:0|武将id}
function ACK_GOODS_EQUIP_BACK.getPartner(self)
	return self.partner
end

-- {装备数量}
function ACK_GOODS_EQUIP_BACK.getCount(self)
	return self.count
end

-- {装备物品信息块2001}
function ACK_GOODS_EQUIP_BACK.getMsgGroup(self)
	return self.msg_group
end

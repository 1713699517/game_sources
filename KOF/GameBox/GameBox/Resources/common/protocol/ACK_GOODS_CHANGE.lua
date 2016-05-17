
require "common/AcknowledgementMessage"

-- [2050]物品/装备属性变化 -- 物品/背包 

ACK_GOODS_CHANGE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_CHANGE
	self:init()
end)


function ACK_GOODS_CHANGE.deserialize(self, reader)    
	self.type        = reader:readInt8Unsigned()  -- {1:背包 2:装备 3:临时背包}
	self.id          = reader:readInt32Unsigned() -- {装备栏时,0:主将|伙伴ID}
	self.count       = reader:readInt16Unsigned() -- {装备数量}
    print("YYYYYYYYYYYYYYYY", self.type, self.id, self.count)    
	--self.goods_msg_no = reader:readXXXGroup()
    print(self.type,self.id,self.count)            -- {物品信息块(2001 P_GOODS_XXX1)}
    local icount = 1
    self.goods_msg_no = {}
    while icount <= self.count do
        print("第 "..icount.." 个物品:")
        local tempData = ACK_GOODS_XXX1()
        tempData :deserialize( reader)
        self.goods_msg_no[icount] = tempData
        icount = icount + 1
    end
end



-- {1:背包 2:装备 3:临时背包}
function ACK_GOODS_CHANGE.getType(self)
	return self.type
end

-- {装备栏时,0:主将|伙伴ID}
function ACK_GOODS_CHANGE.getId(self)
	return self.id
end

-- {物品数量}
function ACK_GOODS_CHANGE.getCount(self)
	return self.count
end

-- {物品信息块(2001)}
function ACK_GOODS_CHANGE.getGoodsMsgNo(self)
	return self.goods_msg_no
end

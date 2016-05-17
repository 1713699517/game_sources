
require "common/AcknowledgementMessage"

-- [2020]请求返回数据 -- 物品/背包

ACK_GOODS_REVERSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_REVERSE
	self:init()
end)

function ACK_GOODS_REVERSE.deserialize(self, reader)
    CCLOG("000000000000000000000000000   1")
	self.uid         = reader:readInt32Unsigned() -- {玩家UID}
	self.type        = reader:readInt8Unsigned() -- {1:背包 2:装备 3:临时背包}
	self.maximum     = reader:readInt16Unsigned() -- {最大容量，装备时为0}
	self.goods_count = reader:readInt16Unsigned() -- {物品数量}

	--self.goods_msg_no = reader:readXXXGroup()   -- {物品信息块(2001 P_GOODS_XXX1)}
    local icount = 1
    self.goods_msg_no = {}
    while icount <= self.goods_count do
        print("第 "..icount.." 个物品:")
        local tempData = ACK_GOODS_XXX1()
        tempData :deserialize( reader)
        self.goods_msg_no[icount] = tempData
        icount = icount + 1
    end
    CCLOG("000000000000000000000000000   2")
end

-- {玩家UID}
function ACK_GOODS_REVERSE.getUid(self)
	return self.uid
end

-- {1:背包 2:装备 3:临时背包}
function ACK_GOODS_REVERSE.getType(self)
	return self.type
end

-- {最大容量，装备时为0}
function ACK_GOODS_REVERSE.getMaximum(self)
	return self.maximum
end

-- {物品数量}
function ACK_GOODS_REVERSE.getGoodsCount(self)
	return self.goods_count
end

-- {物品信息块(2001)}
function ACK_GOODS_REVERSE.getGoodsMsgNo(self)
	return self.goods_msg_no
end

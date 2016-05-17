
require "common/AcknowledgementMessage"

-- (手动) -- [47285]返回商店面板数据（new） -- 珍宝阁系统 

ACK_TREASURE_SHOP_INFO_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_SHOP_INFO_NEW
	self:init()
end)

function ACK_TREASURE_SHOP_INFO_NEW.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {倒计时的时间}
	self.count = reader:readInt16Unsigned() -- {数量}
    self.goods_id_no = {}   -- {物品信息块(47280 P_GOODS_XXX1)}
    local icount = 1
    while icount <= self.count do
        self.goods_id_no[icount] = {}
        self.goods_id_no[icount].goods_id    = reader: readInt32Unsigned()
        self.goods_id_no[icount].goods_count = reader: readInt32Unsigned()
        self.goods_id_no[icount].state       = reader: readInt8Unsigned()
        print("闪电商店 new===",self.goods_id_no[icount].goods_id)
        icount = icount + 1
    end
end

-- {倒计时的时间}
function ACK_TREASURE_SHOP_INFO_NEW.getTime(self)
	return self.time
end

-- {数量}
function ACK_TREASURE_SHOP_INFO_NEW.getCount(self)
	return self.count
end

-- {物品id}
function ACK_TREASURE_SHOP_INFO_NEW.getGoodsIdNo(self)
	return self.goods_id_no
end


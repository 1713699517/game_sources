require "common/AcknowledgementMessage"


-- (手动) -- [47280]返回商店面板数据 -- 藏宝阁系统


ACK_TREASURE_SHOP_INFO = class(CAcknowledgementMessage,function(self)
                               self.MsgID = Protocol.ACK_TREASURE_SHOP_INFO
                               self:init()
                               end)


function ACK_TREASURE_SHOP_INFO.deserialize(self, reader)
    self.time = reader:readInt32Unsigned() -- {倒计时的时间}
    self.count = reader:readInt16Unsigned() -- {数量}
    
    self.goods_id_no = {}   -- {物品信息块(47280 P_GOODS_XXX1)}
    local icount = 1
    while icount <= self.count do
        self.goods_id_no[icount] = {}
        self.goods_id_no[icount].goods_id    = reader: readInt32Unsigned()        
        self.goods_id_no[icount].state    = reader: readInt8Unsigned()
        print("闪电商店===",self.goods_id_no[icount].goods_id)
        icount = icount + 1
        
    end
end


-- {倒计时的时间}
function ACK_TREASURE_SHOP_INFO.getTime(self)
    return self.time
end


-- {数量}
function ACK_TREASURE_SHOP_INFO.getCount(self)
    return self.count
end


-- {物品id}
function ACK_TREASURE_SHOP_INFO.getGoodsIdNo(self)
    return self.goods_id_no
end
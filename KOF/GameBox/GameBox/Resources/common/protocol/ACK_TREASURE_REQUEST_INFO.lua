require "common/AcknowledgementMessage"


-- (手动) -- [47210]处理藏宝阁面板请求 -- 藏宝阁系统 


ACK_TREASURE_REQUEST_INFO = class(CAcknowledgementMessage,function(self)
 self.MsgID = Protocol.ACK_TREASURE_REQUEST_INFO
 self:init()
end)


function ACK_TREASURE_REQUEST_INFO.deserialize(self, reader)
 self.level_id = reader:readInt32Unsigned() -- {藏宝阁层次id}
 self.count = reader:readInt16Unsigned() -- {循环变量}
    self.goods_msg_no = {}   -- {物品信息块(47215 P_GOODS_XXX1)}
    local icount = 1
    while icount <= self.count do
        self.goods_msg_no[icount] = {}
        self.goods_msg_no[icount].goods_id    = reader: readInt32Unsigned()
        self.goods_msg_no[icount].state       = reader: readInt8Unsigned()
        icount = icount + 1 
    end
end


-- {藏宝阁层次id}
function ACK_TREASURE_REQUEST_INFO.getLevelId(self)
 return self.level_id
end


-- {循环变量}
function ACK_TREASURE_REQUEST_INFO.getCount(self)
 return self.count
end


-- {47215}
function ACK_TREASURE_REQUEST_INFO.getGoodsMsgNo(self)
 return self.goods_msg_no
end
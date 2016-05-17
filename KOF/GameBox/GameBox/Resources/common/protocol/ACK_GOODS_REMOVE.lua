
require "common/AcknowledgementMessage"

-- [2040]消失物品/装备 -- 物品/背包 

ACK_GOODS_REMOVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_REMOVE
	self:init()
end)

function ACK_GOODS_REMOVE.deserialize(self, reader)
	self.type      = reader:readInt8Unsigned() -- {1:背包 2:装备 3:临时背包}
	self.id        = reader:readInt32Unsigned()  -- {装备栏时,0:主将|伙伴ID}
	self.count     = reader:readInt16Unsigned() -- {物品数量}
    
    local i = 1
    self.index = {}
    while i <= self.count do
        self.index[i]     = reader:readInt16Unsigned() -- {所在容器位置索引}
        i = i + 1
    end
	
    print("物品消失XXXXXXXXXXXXXX：", self,"物品数量：",self.count)
    
    if self.type == 1 then
        print("在背包：",self.index,"的物品：",self.count,"件 消失")
    elseif self.type == 2 then
        print("在装备栏：",self.index,"的物品：",self.count,"件 消失")
    elseif self.type == 3 then
        print("在临时背包：",self.index,"的物品：",self.count,"件 消失")
    end    
end

-- {1:背包 2:装备 3:临时背包}
function ACK_GOODS_REMOVE.getType(self)
	return self.type
end

-- {装备栏时,0:主将|伙伴ID}
function ACK_GOODS_REMOVE.getId(self)
	return self.id
end

-- {物品数量}
function ACK_GOODS_REMOVE.getCount(self)
	return self.count
end

-- {所在容器位置索引}
function ACK_GOODS_REMOVE.getIndex(self)
	return self.index
end

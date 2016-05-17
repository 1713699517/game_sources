
require "common/AcknowledgementMessage"

-- [2517]下一级装备强化数据返回 -- 物品/打造/强化 

ACK_MAKE_STREN_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_STREN_DATA_BACK
	self:init()
end)

function ACK_MAKE_STREN_DATA_BACK.deserialize(self, reader)
	self.ref      = reader:readInt8Unsigned() -- {标识}
	self.goods_id = reader:readInt16Unsigned() -- {物品ID}
	self.lv = reader:readInt16Unsigned() -- {物品等级}
	self.color = reader:readInt8Unsigned() -- {物品颜色}
	self.cost_coin = reader:readInt32Unsigned() -- {消耗银元}
	self.count = reader:readInt16Unsigned() -- {属性数量}
	--self.msg_xxx = reader:readXXXGroup() -- {信息块2518}
        print("2517 11 你看你发的是什么东西",self.ref,self.goods_id,self.lv,self.color,self.cost_coin,self.count)
    self.data = {}
    if self.count > 0 then
        for icount=1, self.count do
            self.data[icount] = {}
            self.data[icount].type       = reader:readInt16Unsigned() -- 属性类型
            self.data[icount].type_value = reader:readInt16Unsigned() -- 属性值
        end
    end
end

-- {标识}
function ACK_MAKE_STREN_DATA_BACK.getRef(self)
	return self.ref
end

-- {物品ID}
function ACK_MAKE_STREN_DATA_BACK.getGoodsId(self)
	return self.goods_id
end


-- {物品等级}
function ACK_MAKE_STREN_DATA_BACK.getLv(self)
	return self.lv
end

-- {物品颜色}
function ACK_MAKE_STREN_DATA_BACK.getColor(self)
	return self.color
end

-- {消耗银元}
function ACK_MAKE_STREN_DATA_BACK.getCostCoin(self)
	return self.cost_coin
end

-- {属性数量}
function ACK_MAKE_STREN_DATA_BACK.getCount(self)
	return self.count
end

-- {信息块2518}
function ACK_MAKE_STREN_DATA_BACK.getMsg(self)
	return self.data
end

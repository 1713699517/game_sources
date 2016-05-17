
require "common/AcknowledgementMessage"

-- [2001]物品信息块 -- 物品/背包 @@@@@@@

ACK_GOODS_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_XXX1
	self:init()
    print(" [2001]物品信息块 -- 物品/背包")
end)


function ACK_GOODS_XXX1.deserialize(self, reader)
    self.is_data     = reader: readBoolean()
    self.index       = reader: readInt16Unsigned()
    self.goods_id    = reader: readInt16Unsigned()
    self.goods_num   = reader: readInt16Unsigned()
    self.expiry      = reader: readInt32Unsigned()
    self.time        = reader: readInt32Unsigned()
    self.price       = reader: readInt32Unsigned()
    self.goods_type  = reader: readInt8Unsigned()
    print(" 物品ID:"..self.goods_id.."索引Index:"..self.index.."数量:"..self.goods_num.."价格:"..self.price)
    
    if self.goods_type == _G.Constant.CONST_GOODS_EQUIP or self.goods_type == _G.Constant.CONST_GOODS_WEAPON or self.goods_type == _G.Constant.CONST_GOODS_MAGIC then   --装备大类 1 2 5
        self.powerful    = reader: readInt32Unsigned()
        self.pearl_score = reader: readInt32Unsigned()
        self.suit_id     = reader: readInt16Unsigned()
        self.wskill_id   = reader: readInt16Unsigned()
        self.attr_count  = reader: readInt16Unsigned()
        --attr_data  = msg.readXXXGroup(); -- {基础信息块(2006 P_GOODS_ATTR_BASE)}
        local icount = 1
        self.attr_data = {}
        while icount <= self.attr_count do
            print("第 "..icount.." 个属性:")
            local tempData = ACK_GOODS_ATTR_BASE()
            tempData :deserialize( reader)
            self.attr_data[icount] = tempData
            icount = icount + 1
        end
        self.strengthen  = reader: readInt8Unsigned()
        self.plus_count  = reader: readInt16Unsigned()
        --plusmsgno = msg.readXXXGroup();  -- {装备打造附加块(2004 P_GOODS_XXX4)} ACK_GOODS_XXX4
        local icount2 = 1
        self.plus_msg_no = {}
        while icount2 <= self.plus_count do
            print("第 "..icount2.." 个附加属性:")
            local tempData = ACK_GOODS_XXX4()
            tempData :deserialize( reader)
            self.plus_msg_no[icount2] = tempData
            icount2 = icount2 + 1
        end
        self.slots_count = reader: readInt16Unsigned()
        --slotgroup = msg.readXXXGroup();  -- {插槽信息块(2003 P_GOODS_XXX3)} ACK_GOODS_XXX3
        local icount3 = 1
        self.slot_group = {}
        while icount3 <= self.slots_count do
            print("第 "..icount3.." 个插槽属性:")
            local tempData = ACK_GOODS_XXX3()
            tempData :deserialize( reader)
            self.slot_group[icount3] = tempData
            icount3 = icount3 + 1
        end
        self.fumo  = reader: readInt8Unsigned()
        self.fumoz = reader: readInt32Unsigned()
        print("###############################################", self.fumo, self.fumoz)
        else --非装备
        self.attr1      = reader: readInt32Unsigned()
        self.attr2      = reader: readInt32Unsigned()
        self.attr3      = reader: readInt32Unsigned()
        self.attr4      = reader: readInt32Unsigned()
    end --if
end


-- {是否有数据 false:没 true:有 (选择)}
function ACK_GOODS_XXX1.getIsData(self)
	return self.is_data
end

-- {所在容器位置索引}
function ACK_GOODS_XXX1.getIndex(self)
	return self.index
end

-- {物品ID}
function ACK_GOODS_XXX1.getGoodsId(self)
	return self.goods_id
end

-- {重叠数量}
function ACK_GOODS_XXX1.getGoodsNum(self)
	return self.goods_num
end

-- {失效时间(秒)}
function ACK_GOODS_XXX1.getExpiry(self)
	return self.expiry
end

-- {物品获得时间}
function ACK_GOODS_XXX1.getTime(self)
	return self.time
end

-- {出售价格}
function ACK_GOODS_XXX1.getPrice(self)
	return self.price
end

-- {物品大类(类型-* CONST_GOODS_*)}
function ACK_GOODS_XXX1.getGoodsType(self)
	return self.goods_type
end

-- {装备评分}
function ACK_GOODS_XXX1.getPowerful(self)
	return self.powerful
end

-- {灵珠评分}
function ACK_GOODS_XXX1.getPearlScore(self)
	return self.pearl_score
end

-- {所属的套装ID}
function ACK_GOODS_XXX1.getSuitId(self)
	return self.suit_id
end

-- {武器技能}
function ACK_GOODS_XXX1.getWskillId(self)
	return self.wskill_id
end

-- {基础属性数量}
function ACK_GOODS_XXX1.getAttrCount(self)
	return self.attr_count
end

-- {基础属性数值}
function ACK_GOODS_XXX1.getAttrData(self)
	return self.attr_data
end

-- {强化等级}
function ACK_GOODS_XXX1.getStrengthen(self)
	return self.strengthen
end

-- {附加属性数量}
function ACK_GOODS_XXX1.getPlusCount(self)
	return self.plus_count
end

-- {附加属性信息块}
function ACK_GOODS_XXX1.getPlusMsgNo(self)
	return self.plus_msg_no
end

-- {插槽个数}
function ACK_GOODS_XXX1.getSlotsCount(self)
	return self.slots_count
end

-- {插槽块}
function ACK_GOODS_XXX1.getSlotGroup(self)
	return self.slot_group
end

-- {动态1}
function ACK_GOODS_XXX1.getAttr1(self)
	return self.attr1
end

-- {动态2}
function ACK_GOODS_XXX1.getAttr2(self)
	return self.attr2
end

-- {动态3}
function ACK_GOODS_XXX1.getAttr3(self)
	return self.attr3
end

-- {动态4}
function ACK_GOODS_XXX1.getAttr4(self)
	return self.attr4
end


require "common/AcknowledgementMessage"

-- (手动) -- [34512]请求店铺面板成功 -- 商城 

ACK_SHOP_REQUEST_OK_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_REQUEST_OK_NEW
	self:init()
end)

function ACK_SHOP_REQUEST_OK_NEW.deserialize(self, reader)
	self.type    = reader:readInt16Unsigned() -- {店铺类型}
	self.type_bb = reader:readInt16Unsigned() -- {子店铺类型}
	self.count   = reader:readInt16Unsigned() -- {物品数量}
	--self.msg = reader:readXXXGroup() -- {信息块34502}
    
    self.goods_msg_no = {}   -- {物品信息块(34501 P_GOODS_XXX1)}
    local icount = 1
    while icount <= self.count do
        self.goods_msg_no[icount] = {}
        self.goods_msg_no[icount].idx                = reader: readInt16Unsigned()
        self.goods_msg_no[icount].state              = reader: readInt8Unsigned()
        
        --self.goods_msg_no[icount].msg                = reader: readInt8Unsigned()-- {物品信息块(2001 P_GOODS_XXX1)}
        ----------------------------------------------------------------------------------------------------------
        print("ACK_SHOP_REQUEST_OK第 "..icount.." 个物品:",self.goods_msg_no[icount].idx)
        --[[
         local tempData = ACK_GOODS_XXX1()
         tempData :deserialize( reader)
         self.goods_msg_no[icount] = tempData
         --]]
        ----[[
        self.goods_msg_no[icount].is_data     = reader: readBoolean()
        self.goods_msg_no[icount].index       = reader: readInt16Unsigned()
        self.goods_msg_no[icount].goods_id    = reader: readInt16Unsigned()
        self.goods_msg_no[icount].goods_num   = reader: readInt16Unsigned()
        self.goods_msg_no[icount].expiry      = reader: readInt32Unsigned()
        self.goods_msg_no[icount].time        = reader: readInt32Unsigned()
        self.goods_msg_no[icount].price       = reader: readInt32Unsigned()
        self.goods_msg_no[icount].goods_type  = reader: readInt8Unsigned()
        --print(" 物品ID:"..self.goods_id.."索引Index:"..self.index.."数量:"..self.goods_num.."价格:"..self.price)
        self.goods_type = self.goods_msg_no[icount].goods_type
        if self.goods_type == _G.Constant.CONST_GOODS_EQUIP or self.goods_type == _G.Constant.CONST_GOODS_WEAPON or self.goods_type == _G.Constant.CONST_GOODS_MAGIC then   --装备大类 1 2 5
            self.goods_msg_no[icount].powerful    = reader: readInt32Unsigned()
            self.goods_msg_no[icount].pearl_score = reader: readInt32Unsigned()
            self.goods_msg_no[icount].suit_id     = reader: readInt16Unsigned()
            self.goods_msg_no[icount].wskill_id   = reader: readInt16Unsigned()
            self.goods_msg_no[icount].attr_count  = reader: readInt16Unsigned()
            self.attr_count = self.goods_msg_no[icount].attr_count
            --attr_data  = msg.readXXXGroup(); -- {基础信息块(2006 P_GOODS_ATTR_BASE)}
            local icount1 = 1
            self.goods_msg_no[icount].attr_data = {}
            while icount1 <= self.attr_count do
                print("第 "..icount.." 个属性:")
                local tempData = ACK_GOODS_ATTR_BASE()
                tempData :deserialize( reader)
                self.goods_msg_no[icount].attr_data[icount1] = tempData
                icount1 = icount1 + 1
            end
            self.goods_msg_no[icount].strengthen  = reader: readInt8Unsigned()
            self.goods_msg_no[icount].plus_count  = reader: readInt16Unsigned()
            self.plus_count = self.goods_msg_no[icount].plus_count
            --plusmsgno = msg.readXXXGroup();  -- {装备打造附加块(2004 P_GOODS_XXX4)} ACK_GOODS_XXX4
            local icount2 = 1
            self.goods_msg_no[icount].plus_msg_no = {}
            while icount2 <= self.plus_count do
                print("第 "..icount2.." 个附加属性:")
                local tempData = ACK_GOODS_XXX4()
                tempData :deserialize( reader)
                self.goods_msg_no[icount].plus_msg_no[icount2] = tempData
                icount2 = icount2 + 1
            end
            self.goods_msg_no[icount].slots_count = reader: readInt16Unsigned()
            self.slots_count = self.goods_msg_no[icount].slots_count
            --slotgroup = msg.readXXXGroup();  -- {插槽信息块(2003 P_GOODS_XXX3)} ACK_GOODS_XXX3
            local icount3 = 1
            self.goods_msg_no[icount].slot_group = {}
            while icount3 <= self.slots_count do
                print("第 "..icount3.." 个插槽属性:")
                local tempData = ACK_GOODS_XXX3()
                tempData :deserialize( reader)
                self.goods_msg_no[icount].slot_group[icount3] = tempData
                icount3 = icount3 + 1
            end
            self.goods_msg_no[icount].fumo  = reader: readInt8Unsigned()
            self.goods_msg_no[icount].fumoz = reader: readInt32Unsigned()
            print("###############################################", self.fumo, self.fumoz)
            else --非装备
            self.goods_msg_no[icount].attr1      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr2      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr3      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr4      = reader: readInt32Unsigned()
        end --if
        ----]]
        ----------------------------------------------------------------------------------------------------------
        self.goods_msg_no[icount].type               = reader: readInt8Unsigned()
        self.goods_msg_no[icount].s_price            = reader: readInt32Unsigned()
        self.goods_msg_no[icount].v_price            = reader: readInt32Unsigned()
        self.goods_msg_no[icount].etra_type          = reader: readInt8Unsigned()
        self.goods_msg_no[icount].etra_value         = reader: readInt16Unsigned()

        icount = icount + 1
    end
    
	self.end_time = reader:readInt32Unsigned() -- {结束时间}
end

-- {店铺类型}
function ACK_SHOP_REQUEST_OK_NEW.getType(self)
	return self.type
end

-- {子店铺类型}
function ACK_SHOP_REQUEST_OK_NEW.getTypeBb(self)
	return self.type_bb
end

-- {物品数量}
function ACK_SHOP_REQUEST_OK_NEW.getCount(self)
	return self.count
end

-- {信息块34502}
function ACK_SHOP_REQUEST_OK_NEW.getMsg(self)
	return self.goods_msg_no
end

-- {结束时间}
function ACK_SHOP_REQUEST_OK_NEW.getEndTime(self)
	return self.end_time
end

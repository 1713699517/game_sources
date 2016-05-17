
require "common/AcknowledgementMessage"

-- [9530]收到频道聊天 -- 聊天 

ACK_CHAT_RECE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CHAT_RECE
	self:init()
end)


function ACK_CHAT_RECE.deserialize(self, reader)    
	self.channel_id        	= reader:readInt8Unsigned()
	self.uid       			= reader:readInt32Unsigned()
	self.uname 				= reader:readString()
	self.sex 				= reader:readInt8Unsigned()
	self.pro 				= reader:readInt8Unsigned()
	self.lv 				= reader:readInt16Unsigned()
	self.country_id 		= reader:readInt8Unsigned()
	self.r_uid 				= reader:readInt32Unsigned()
    self.r_name             = reader:readString()
    self.r_pro 				= reader:readInt8Unsigned()
    self.r_lv 				= reader:readInt16Unsigned()
    print("###########:", self.channel_id, self.uid, self.uname,"/",self.r_uid,self.r_name)
	self.title_count 		= reader:readInt16Unsigned()
    self.title_id = {}
    print(self.title_count,"title_count")
	for i=1,self.title_count do
		self.title_id[i]    = reader:readIn8Unsigned()
	end
    self.msg 				= reader:readUTF()
	self.arg_type      		= reader:readInt8Unsigned()
    self.team_id			= reader:readInt16Unsigned()
    self.copy_id			= reader:readInt16Unsigned()    
	self.goods_count 		= reader:readInt16Unsigned()
	local icount = 1
    print(self.goods_count,"goods_count")
    self.goods_msg_no = {}
	while icount <= self.goods_count do
		self.goods_msg_no[ icount ] = {}
		self.goods_msg_no[icount].is_data     = reader: readBoolean()
        self.goods_msg_no[icount].index       = reader: readInt16Unsigned()
        self.goods_msg_no[icount].goods_id    = reader: readInt16Unsigned()
        self.goods_msg_no[icount].goods_num   = reader: readInt16Unsigned()
        self.goods_msg_no[icount].expiry      = reader: readInt32Unsigned()
        self.goods_msg_no[icount].time        = reader: readInt32Unsigned()
        self.goods_msg_no[icount].price       = reader: readInt32Unsigned()
        self.goods_msg_no[icount].goods_type  = reader: readInt8Unsigned()
        if self.goods_msg_no[icount].goods_type == 1 or self.goods_msg_no[icount].goods_type == 2 or self.goods_msg_no[icount].goods_type == 5 then   --装备大类 1
            self.goods_msg_no[icount].powerful    = reader: readInt32Unsigned()
            self.goods_msg_no[icount].pearl_score = reader: readInt32Unsigned()
            self.goods_msg_no[icount].suit_id     = reader: readInt16Unsigned()
            self.goods_msg_no[icount].wskill_id   = reader: readInt16Unsigned()
            self.goods_msg_no[icount].attr_count  = reader: readInt16Unsigned()
            --attrdata  = msg.readXXXGroup(); -- {基础信息块(2006 P_GOODS_ATTR_BASE)}
            self.goods_msg_no[icount]["attr_data"]  = {}
            local icount1 = 1
            while icount1 <= self.goods_msg_no[icount].attr_count do
                self.goods_msg_no[icount]["attr_data"][icount1] = {}
                self.goods_msg_no[icount]["attr_data"][icount1].attr_base_type  = reader: readInt16Unsigned()
                self.goods_msg_no[icount]["attr_data"][icount1].attr_base_value = reader: readInt32Unsigned()
                icount1 = icount1 + 1
            end
            self.goods_msg_no[icount].strengthen  = reader: readInt8Unsigned()
            self.goods_msg_no[icount].plus_count  = reader: readInt16Unsigned()
            --plusmsgno = msg.readXXXGroup();  -- {装备打造附加块(2004 P_GOODS_XXX4)}
            self.goods_msg_no[icount]["plus_msg_no"] = {}
            local icount2 = 1
            while icount2 <= self.goods_msg_no[icount].plus_count do
                self.goods_msg_no[icount]["plus_msg_no"][icount2] = {}
                self.goods_msg_no[icount]["plus_msg_no"][icount2].plus_type    = reader: readInt8Unsigned();
                self.goods_msg_no[icount]["plus_msg_no"][icount2].plus_colour  = reader: readInt8Unsigned();
                self.goods_msg_no[icount]["plus_msg_no"][icount2].plus_current = reader: readInt16Unsigned();
                self.goods_msg_no[icount]["plus_msg_no"][icount2].plus_max     = reader: readInt16Unsigned();
                icount2 = icount2 + 1
            end
            self.goods_msg_no[icount].slots_count = reader: readInt16Unsigned()
            --slotgroup = msg.readXXXGroup();  -- {插槽信息块(2003 P_GOODS_XXX3)}
            self.goods_msg_no[icount]["slot_group"] = {}
            local icount3 = 1
            while icount3 <= self.goods_msg_no[icount].slots_count do
                self.goods_msg_no[icount]["slot_group"][icount3] = {}
                self.goods_msg_no[icount]["slot_group"][icount3].slot_flag     = reader: readBoolean();
                if self.goods_msg_no[icount]["slot_group"][icount3].slot_flag then
                    self.goods_msg_no[icount]["slot_group"][icount3].slot_pearl_id = reader: readInt16Unsigned();
                    self.goods_msg_no[icount]["slot_group"][icount3].count         = reader: readInt16Unsigned();
                    --msggroup = msg.readXXXGroup();  -- {插槽属性块(2003 P_GOODS_XXX5)}
                    self.goods_msg_no[icount]["slot_group"][icount3].msg_group = {}
                    local icount4 = 1
                    while icount4 <= self.goods_msg_no[icount]["slot_group"][icount3].count do
                        self.goods_msg_no[icount]["slot_group"][icount3]["msg_group"][icount4] = {}
                        self.goods_msg_no[icount]["slot_group"][icount3]["msg_group"][icount4].slot_attr_type  = reader: readInt8Unsigned();
                        self.goods_msg_no[icount]["slot_group"][icount3]["msg_group"][icount4].slot_attr_value = reader: readInt32Unsigned();
                        icount4 = icount4 + 1
                    end
                end
                icount3 = icount3 + 1
            end
            self.goods_msg_no[icount].fumo  = reader: readInt8Unsigned()
            self.goods_msg_no[icount].fumoz = reader: readInt32Unsigned()
            else --非装备
            self.goods_msg_no[icount].attr1      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr2      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr3      = reader: readInt32Unsigned()
            self.goods_msg_no[icount].attr4      = reader: readInt32Unsigned()
        end --if
        icount = icount +1
	end
end









-- {频道类型}
function ACK_CHAT_RECE.getChannelId(self)
	return self.channel_id
end

-- {服务器ID}
function ACK_CHAT_RECE.getSid(self)
	return self.sid
end

-- {用户id}
function ACK_CHAT_RECE.getUid(self)
	return self.uid
end

-- {用户名称}
function ACK_CHAT_RECE.getUname(self)
	return self.uname
end

-- {性别}
function ACK_CHAT_RECE.getSex(self)
	return self.sex
end

-- {职业}
function ACK_CHAT_RECE.getPro(self)
	return self.pro
end

-- {等级}
function ACK_CHAT_RECE.getLv(self)
	return self.lv
end

-- {阵营类型}
function ACK_CHAT_RECE.getCountryId(self)
	return self.country_id
end

-- {接收者的用户Id}
function ACK_CHAT_RECE.getRUid(self)
	return self.r_uid
end

-- {接收者的名称}
function ACK_CHAT_RECE.getRName(self)
    return self.r_name
end


-- {职业}
function ACK_CHAT_RECE.getRPro(self)
    return self.r_pro
end

-- {等级}
function ACK_CHAT_RECE.getRLv(self)
    return self.r_lv
end


-- {称号数量}
function ACK_CHAT_RECE.getTitleCount(self)
	return self.title_count
end

-- {称号ID}
function ACK_CHAT_RECE.getTitleId(self)
	return self.title_id
end

-- {常量}
function ACK_CHAT_RECE.getArg_type(self)
	return self.arg_type
end

-- {物品数量}
function ACK_CHAT_RECE.getGoodsCount(self)
	return self.goods_count
end

-- {物品信息块(2001)}
function ACK_CHAT_RECE.getGoodsMsgNo(self)
	return self.goods_msg_no
end

-- {队伍id}
function ACK_CHAT_RECE.getTeam_id(self)
	return self.team_id
end

-- {场景id}
function ACK_CHAT_RECE.getCopy_id(self)
	return self.copy_id
end

-- {聊天内容}
function ACK_CHAT_RECE.getMsg(self)
	return self.msg
end

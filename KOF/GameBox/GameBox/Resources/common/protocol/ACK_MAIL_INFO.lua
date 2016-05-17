
require "common/AcknowledgementMessage"

-- [8542]读取邮件成功 -- 邮件 

ACK_MAIL_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_INFO
	self:init()
end)

function ACK_MAIL_INFO.deserialize(self, reader)
    self.mail_id        = reader:readInt32Unsigned()
    self.send_uid       = reader:readInt32Unsigned()
    self.state          = reader:readInt8Unsigned()
    self.pick           = reader:readInt8Unsigned()
    self.content        = reader:readUTF()
    --附件虚拟物品数量
    self.count_v        = reader:readInt16Unsigned()
    if self.count_v > 0 then
        self.vgoods_msg  = {}       -- {虚拟物品信息块[8543]}
        
        for i=1, self.count_v do
            self.vgoods_msg[i] = {}
            
            self.vgoods_msg[i].type = reader:readInt8Unsigned()
            self.vgoods_msg[i].count= reader:readInt32Unsigned()
        end
    end
    
    --附件实体物品数量
    self.count_u        = reader:readInt16Unsigned() -- {物品信息块(2001 P_GOODS_XXX1)}    
    local icount = 1
    self.ugoods_msg = {}
    while icount <= self.count_u do
        print("第 "..icount.." 个物品:")
        local tempData = ACK_GOODS_XXX1()
        tempData :deserialize( reader)
        self.ugoods_msg[icount] = tempData
        icount = icount + 1
    end
    
    print("邮件id", "发件人uid", "邮件状态", "附件是否提取", "内容","附件虚拟物品数 (循环)")
    --print(self.mail_id, self.send_uid, self.state, self.pick, self.content, self.count_v)
    
    --[[
    for k, v in pairs( self.ugoods_msg) do
       print("实体物品", k, v.goods_id, v.goods_num)
    end
    --]]
end

-- {邮件Id}
function ACK_MAIL_INFO.getMailId(self)
	return self.mail_id
end

-- {发件人Uid}
function ACK_MAIL_INFO.getSendUid(self)
	return self.send_uid
end

-- {邮件状态(未读:0|已读:1)}
function ACK_MAIL_INFO.getState(self)
	return self.state
end

-- {附件是否提取(无附件:0|未提取:1|已提取:2)}
function ACK_MAIL_INFO.getPick(self)
	return self.pick
end

-- {内容}
function ACK_MAIL_INFO.getContent(self)
	return self.content
end

-- {附件虚拟物品数}
function ACK_MAIL_INFO.getCountV(self)
	return self.count_v
end

-- {虚拟物品信息块[8543]}
function ACK_MAIL_INFO.getVgoodsMsg(self)
	return self.vgoods_msg
end

-- {附件实体物品数}
function ACK_MAIL_INFO.getCountU(self)
	return self.count_u
end

-- {实体物品信息块2001}
function ACK_MAIL_INFO.getUgoodsMsg(self)
	return self.ugoods_msg
end

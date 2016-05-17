
require "common/AcknowledgementMessage"

-- [3520]队伍面板回复 -- 组队系统 

ACK_TEAM_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_REPLY
	self:init()
end)

function ACK_TEAM_REPLY.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见：CONST_COPY_TYPE_*}
	self.count = reader:readInt16Unsigned() -- {队伍数量}
	--self.msg = reader:readXXXGroup() -- {队伍模块(3530)}
    local icount = 1
    self.goods_msg_no = {}
    while icount <=  self.count do
        self.goods_msg_no[icount] = {}
        self.goods_msg_no[icount].team_id     = reader:readInt32Unsigned() --队伍ID
        self.goods_msg_no[icount].copy_id     = reader:readInt16Unsigned() --副本ID
        self.goods_msg_no[icount].leader_name = reader:readString()        --队长姓名
        self.goods_msg_no[icount].leader_lv   = reader:readInt16Unsigned() --队长lv
        self.goods_msg_no[icount].num         = reader:readInt16Unsigned() --队员数量
        print("-------------->",self.goods_msg_no[icount].team_id,self.goods_msg_no[icount].copy_id,self.goods_msg_no[icount].leader_name,self.goods_msg_no[icount].num)
        icount = icount + 1
    end
    
end

-- {详见：CONST_COPY_TYPE_*}
function ACK_TEAM_REPLY.getType(self)
	return self.type
end

-- {队伍数量}
function ACK_TEAM_REPLY.getCount(self)
	return self.count
end

-- {队伍模块(3530)}
function ACK_TEAM_REPLY.getMsg(self)
	return self.goods_msg_no
end

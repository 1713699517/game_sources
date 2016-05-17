
require "common/AcknowledgementMessage"

-- (手动) -- [3572]队伍信息返回(new) -- 组队系统 

ACK_TEAM_TEAM_INFO_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_TEAM_INFO_NEW
	self:init()
end)

function ACK_TEAM_TEAM_INFO_NEW.deserialize(self, reader)
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.leader_uid = reader:readInt32Unsigned() -- {队长UID}
	self.count = reader:readInt16Unsigned() -- {成员数量}
	--self.data = reader:readXXXGroup() -- {成员信息块(3574)}
    
    local icount = 1
    self.goods_msg_no = {}
    while icount <=  self.count do
        self.goods_msg_no[icount] = {}
        self.goods_msg_no[icount].uid        = reader:readInt32Unsigned() --队伍Uid
        self.goods_msg_no[icount].name       = reader:readString()        --队伍姓名
        self.goods_msg_no[icount].name_color = reader:readInt8Unsigned()  --队员姓名颜色
        self.goods_msg_no[icount].lv         = reader:readInt16Unsigned() --队员等级
        self.goods_msg_no[icount].pos        = reader:readInt8Unsigned()  --队员位置(1,2,3,4)
        self.goods_msg_no[icount].power      = reader:readInt32Unsigned() --队员战斗力
        self.goods_msg_no[icount].clan_name  = reader:readString()        --社团名字
        if self.goods_msg_no[icount].clan_name == nil then
            self.goods_msg_no[icount].clan_name = "-1"
        end
        self.goods_msg_no[icount].pro        = reader:readInt8Unsigned() --队员职业
        
        print("----444--->",self.goods_msg_no[icount].uid,self.goods_msg_no[icount].name,self.goods_msg_no[icount].name_color,self.goods_msg_no[icount].lv,self.goods_msg_no[icount].pos,self.goods_msg_no[icount].power,self.goods_msg_no[icount].clan_name)
        icount = icount + 1
    end
end

-- {队伍ID}
function ACK_TEAM_TEAM_INFO_NEW.getTeamId(self)
	return self.team_id
end

-- {副本ID}
function ACK_TEAM_TEAM_INFO_NEW.getCopyId(self)
	return self.copy_id
end

-- {队长UID}
function ACK_TEAM_TEAM_INFO_NEW.getLeaderUid(self)
	return self.leader_uid
end

-- {成员数量}
function ACK_TEAM_TEAM_INFO_NEW.getCount(self)
	return self.count
end

-- {成员信息块(3574)}
function ACK_TEAM_TEAM_INFO_NEW.getData(self)
	return self.goods_msg_no
end

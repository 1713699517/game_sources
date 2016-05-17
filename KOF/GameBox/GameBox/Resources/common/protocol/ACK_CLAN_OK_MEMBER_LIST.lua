
require "common/AcknowledgementMessage"

-- [33140]返回社团成员列表 -- 社团 

ACK_CLAN_OK_MEMBER_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_MEMBER_LIST
	self:init()
end)

function ACK_CLAN_OK_MEMBER_LIST.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
    print("社团成员列表:", self.count)
	--self.member_msg = reader:readXXXGroup() -- {成员数据信息块【33145】}
    local icount = 1
    self.member_msg = {}
    while icount <= self.count do
        self.member_msg[icount] = {}
        self.member_msg[icount].uid         = reader:readInt32Unsigned() -- {玩家Uid}
        self.member_msg[icount].name        = reader:readString()        -- {玩家名字}
        self.member_msg[icount].name_color  = reader:readInt8Unsigned()  -- {玩家名字颜色}
        self.member_msg[icount].lv          = reader:readInt16Unsigned() -- {玩家等级}
        self.member_msg[icount].pro         = reader:readInt8Unsigned()  -- {职业}
        self.member_msg[icount].post        = reader:readInt8Unsigned()  -- {职位}
        self.member_msg[icount].today_gx    = reader:readInt32Unsigned() -- {今日贡献}
        self.member_msg[icount].all_gx      = reader:readInt32Unsigned() -- {总贡献}
        self.member_msg[icount].time        = reader:readInt32Unsigned() -- {离线时间(s) 1表示在线}   
        print("玩家名字:", self.member_msg[icount].name)
        icount = icount + 1
    end
end

-- {数量}
function ACK_CLAN_OK_MEMBER_LIST.getCount(self)
	return self.count
end

-- {成员数据信息块【33145】}
function ACK_CLAN_OK_MEMBER_LIST.getMemberMsg(self)
	return self.member_msg
end

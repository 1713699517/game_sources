
require "common/AcknowledgementMessage"

-- [33080]返回入帮申请列表 -- 社团 

ACK_CLAN_OK_JOIN_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_JOIN_LIST
	self:init()
end)

function ACK_CLAN_OK_JOIN_LIST.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
    print( "入帮申请列表:", self.count)
	--self.user_data = reader:readXXXGroup() -- {入帮申请玩家信息块【33085】}
    local icount = 1
    self.user_data = {}
    while icount <= self.count do
        self.user_data[icount] = {}
        self.user_data[icount].uid        = reader:readInt32Unsigned() -- {玩家Uid}
        self.user_data[icount].name       = reader:readString() -- {玩家名字}
        self.user_data[icount].name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
        self.user_data[icount].lv         = reader:readInt16Unsigned() -- {等级}
        self.user_data[icount].pro        = reader:readInt8Unsigned() -- {职业}
        self.user_data[icount].time       = reader:readInt32Unsigned() -- {申请时间戳(s)}     
        print("DDDDDD:",self.user_data[icount].name,self.user_data[icount].lv)
        icount = icount + 1
    end
end

-- {数量}
function ACK_CLAN_OK_JOIN_LIST.getCount(self)
	return self.count
end

-- {入帮申请玩家信息块【33085】}
function ACK_CLAN_OK_JOIN_LIST.getUserData(self)
	return self.user_data
end

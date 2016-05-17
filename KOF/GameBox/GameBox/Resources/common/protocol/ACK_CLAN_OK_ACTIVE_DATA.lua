
require "common/AcknowledgementMessage"

-- [33310]返回活动面板数据 -- 社团 

ACK_CLAN_OK_ACTIVE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_ACTIVE_DATA
	self:init()
end)

function ACK_CLAN_OK_ACTIVE_DATA.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
    print("社团活动数量 :"..self.count)
	--self.active_data = reader:readXXXGroup() -- {社团活动数据块【33315】} ACK_CLAN_ACTIVE_MSG
    local icount = 1
    self.active_data = {}
    while icount <= self.count do
        print("第 "..icount.." 个社团活动数据:")
        local tempData = ACK_CLAN_ACTIVE_MSG()
        tempData :deserialize( reader)
        self.active_data[icount] = tempData
        icount = icount + 1
    end
end

-- {数量}
function ACK_CLAN_OK_ACTIVE_DATA.getCount(self)
	return self.count
end

-- {社团活动数据块【33315】}
function ACK_CLAN_OK_ACTIVE_DATA.getActiveData(self)
	return self.active_data
end

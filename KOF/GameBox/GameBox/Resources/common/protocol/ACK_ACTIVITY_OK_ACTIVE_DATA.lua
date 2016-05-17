
require "common/AcknowledgementMessage"

-- [30520]活动数据返回 -- 活动面板 

ACK_ACTIVITY_OK_ACTIVE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_OK_ACTIVE_DATA
	self:init()
end)

function ACK_ACTIVITY_OK_ACTIVE_DATA.deserialize(self, reader)
	self.count = reader:readInt8Unsigned() -- {数量}
    print("-- [30520]活动数据返回 -- 活动面板: 数量 "..self.count)
	--self.active_msg = reader:readXXXGroup() -- {活动数据}
    local icount = 1
    self.active_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个活动:")
        local tempData = ACK_ACTIVITY_ACTIVE_DATA()
        tempData :deserialize( reader)
        self.active_msg[icount] = tempData
        icount = icount + 1
    end    
end

-- {数量}
function ACK_ACTIVITY_OK_ACTIVE_DATA.getCount(self)
	return self.count
end

-- {活动数据}
function ACK_ACTIVITY_OK_ACTIVE_DATA.getActiveMsg(self)
	return self.active_msg
end

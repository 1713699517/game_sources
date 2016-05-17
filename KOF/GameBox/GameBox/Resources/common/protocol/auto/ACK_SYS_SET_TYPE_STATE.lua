
require "common/AcknowledgementMessage"

-- (手动) -- [56820]各功能状态 -- 系统设置 

ACK_SYS_SET_TYPE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_SET_TYPE_STATE
	self:init()
end)

function ACK_SYS_SET_TYPE_STATE.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {功能数量}
	self.data = {}--reader:readXXXGroup() -- {信息快(56830)}
    
    local iCount = 1
    
    while iCount <= self.count do
        self.data[iCount] = {}
        
        self.data[iCount].type  = reader:readInt16Unsigned()
        self.data[iCount].state = reader:readInt8Unsigned()
        
        iCount = iCount + 1
    end
end

-- {功能数量}
function ACK_SYS_SET_TYPE_STATE.getCount(self)
	return self.count
end

-- {信息快(56830)}
function ACK_SYS_SET_TYPE_STATE.getData(self)
	return self.data
end

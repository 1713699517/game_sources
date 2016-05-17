
require "common/AcknowledgementMessage"

-- [48285]吞噬结果 -- 斗气系统 

ACK_SYS_DOUQI_EAT_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_EAT_STATE
	self:init()
end)

function ACK_SYS_DOUQI_EAT_STATE.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.eat_data = reader:readXXXGroup() -- {吞噬结果信息块【48290】}
    print("一键吞噬总数量:"..self.count)
    local icount = 1
    self.eat_data = {}
    while icount <= self.count do
        print("一键吞噬第:"..icount.." 个吞噬者。")
        local tempData = ACK_SYS_DOUQI_EAT_DATA()
        tempData :deserialize( reader)
        self.eat_data[icount] = tempData
        icount = icount + 1
    end
end

-- {数量}
function ACK_SYS_DOUQI_EAT_STATE.getCount(self)
	return self.count
end

-- {吞噬结果信息块【48290】}
function ACK_SYS_DOUQI_EAT_STATE.getEatData(self)
	return self.eat_data
end

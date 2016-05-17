
require "common/AcknowledgementMessage"

-- [48223]一键领悟数据返回 -- 斗气系统 

ACK_SYS_DOUQI_MORE_GRASP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_MORE_GRASP
	self:init()
end)

function ACK_SYS_DOUQI_MORE_GRASP.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.msg_more = reader:readXXXGroup() -- {48225}
    local icount = 1
    self.msg_more = {}
    while icount <= self.count do
        print( self.count.." 第 "..icount.." 个斗气信息:")
        local tempData = ACK_SYS_DOUQI_MSG_MORE()
        tempData :deserialize( reader)
        self.msg_more[icount] = tempData
        icount = icount + 1
    end
end

-- {数量}
function ACK_SYS_DOUQI_MORE_GRASP.getCount(self)
	return self.count
end

-- {48225}
function ACK_SYS_DOUQI_MORE_GRASP.getMsgMore(self)
	return self.msg_more
end

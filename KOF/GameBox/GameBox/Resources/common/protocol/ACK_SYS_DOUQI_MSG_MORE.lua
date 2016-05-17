
require "common/AcknowledgementMessage"

-- [48225]一键领悟数据 -- 斗气系统 CHorizontalLayout

ACK_SYS_DOUQI_MSG_MORE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_MSG_MORE
	self:init()
end)

function ACK_SYS_DOUQI_MSG_MORE.deserialize(self, reader)
    --print(" -- [48225]一键领悟数据 -- 斗气系统")
	self.type_grasp = reader:readInt16Unsigned() -- {新领悟方式}
	--self.msg_dq     = reader:readXXXGroup() -- {48203}
    print("新的领悟方式: ",self.type_grasp)
    local tempData = ACK_SYS_DOUQI_DOUQI_DATA()
    tempData :deserialize( reader)
    self.msg_dq = tempData    
end

-- {新领悟方式}
function ACK_SYS_DOUQI_MSG_MORE.getTypeGrasp(self)
	return self.type_grasp
end

-- {48203}
function ACK_SYS_DOUQI_MSG_MORE.getMsgDq(self)
	return self.msg_dq
end

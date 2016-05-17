
require "common/AcknowledgementMessage"
require "common/protocol/ACK_TEAM_PASS_MSG"
-- [3550]通关副本返回 -- 组队系统 

ACK_TEAM_PASS_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_PASS_REPLY
	self:init()
end)

function ACK_TEAM_PASS_REPLY.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见：CONST_COPY_TYPE_*}
	self.count = reader:readInt16Unsigned() -- {通关副本数量}
	--self.msg = reader:readXXXGroup() -- {通关副本模块(3560)}
    
    self.msg = {}
    for i=1,self.count do
        local msg = ACK_TEAM_PASS_MSG()
        msg : deserialize( reader )
        table.insert(self.msg , msg )
    end
end

-- {详见：CONST_COPY_TYPE_*}
function ACK_TEAM_PASS_REPLY.getType(self)
	return self.type
end

-- {通关副本数量}
function ACK_TEAM_PASS_REPLY.getCount(self)
	return self.count
end

-- {通关副本模块(3560)}
function ACK_TEAM_PASS_REPLY.getMsg(self)
	return self.msg
end

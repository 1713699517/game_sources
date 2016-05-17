
require "common/AcknowledgementMessage"

-- [1261]请求体力值成功 -- 角色 

ACK_ROLE_ENERGY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_ENERGY_OK
	self:init()
end)

function ACK_ROLE_ENERGY_OK.deserialize(self, reader)
	self.sum = reader:readInt16Unsigned() -- {当前体力值}
	self.max = reader:readInt16Unsigned() -- {最大体力值}
end

-- {当前体力值}
function ACK_ROLE_ENERGY_OK.getSum(self)
	return self.sum
end

-- {最大体力值}
function ACK_ROLE_ENERGY_OK.getMax(self)
	return self.max
end

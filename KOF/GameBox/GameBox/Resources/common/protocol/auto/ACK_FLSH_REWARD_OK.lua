
require "common/AcknowledgementMessage"

-- [50290]领取奖励成功 -- 风林山火 

ACK_FLSH_REWARD_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FLSH_REWARD_OK
	self:init()
end)

function ACK_FLSH_REWARD_OK.deserialize(self, reader)
	self.sz_num = reader:readInt16Unsigned() -- {顺子数}
	self.same_num = reader:readInt16Unsigned() -- {相同牌数}
	self.dz_num = reader:readInt16Unsigned() -- {对子数}
end

-- {顺子数}
function ACK_FLSH_REWARD_OK.getSzNum(self)
	return self.sz_num
end

-- {相同牌数}
function ACK_FLSH_REWARD_OK.getSameNum(self)
	return self.same_num
end

-- {对子数}
function ACK_FLSH_REWARD_OK.getDzNum(self)
	return self.dz_num
end

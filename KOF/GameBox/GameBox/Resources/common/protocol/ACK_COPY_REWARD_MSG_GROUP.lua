
require "common/AcknowledgementMessage"

-- (手动) -- [7670]奖励信息块 -- 副本 

ACK_COPY_REWARD_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_REWARD_MSG_GROUP
	self:init()
end)

function ACK_COPY_REWARD_MSG_GROUP.deserialize(self, reader)
	self.uname = reader:readString() -- {玩家名称}
	self.name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.meterid = reader:readInt32Unsigned() -- {材料ID}
	self.metercount = reader:readInt16Unsigned() -- {材料数量}
end

-- {玩家名称}
function ACK_COPY_REWARD_MSG_GROUP.getUname(self)
	return self.uname
end

-- {玩家名字颜色}
function ACK_COPY_REWARD_MSG_GROUP.getNameColor(self)
	return self.name_color
end

-- {材料ID}
function ACK_COPY_REWARD_MSG_GROUP.getMeterid(self)
	return self.meterid
end

-- {材料数量}
function ACK_COPY_REWARD_MSG_GROUP.getMetercount(self)
	return self.metercount
end

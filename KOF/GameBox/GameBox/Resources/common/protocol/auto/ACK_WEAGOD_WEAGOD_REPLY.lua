
require "common/AcknowledgementMessage"

-- (手动) -- [32010]财神面板请求返回 -- 财神 

ACK_WEAGOD_WEAGOD_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_WEAGOD_REPLY
	self:init()
end)

function ACK_WEAGOD_WEAGOD_REPLY.deserialize(self, reader)
	self.lv = reader:readInt8Unsigned() -- {财神等级}
	self.wealth = reader:readInt32Unsigned() -- {当前财气}
	self.centimes = reader:readInt16Unsigned() -- {当前可上香次数}
	self.pronum = reader:readInt16Unsigned() -- {财神符数量}
	self.weatimes = reader:readInt16Unsigned() -- {当前可招财次数}
	self.qkgold = reader:readInt8Unsigned() -- {是否可一键招财(1：可以 | 0：不可以)}
	self.getweatimes = reader:readInt16Unsigned() -- {当前已招财次数}
	self.getgold = reader:readInt32Unsigned() -- {当前招一次可获得银元}
end

-- {财神等级}
function ACK_WEAGOD_WEAGOD_REPLY.getLv(self)
	return self.lv
end

-- {当前财气}
function ACK_WEAGOD_WEAGOD_REPLY.getWealth(self)
	return self.wealth
end

-- {当前可上香次数}
function ACK_WEAGOD_WEAGOD_REPLY.getCentimes(self)
	return self.centimes
end

-- {财神符数量}
function ACK_WEAGOD_WEAGOD_REPLY.getPronum(self)
	return self.pronum
end

-- {当前可招财次数}
function ACK_WEAGOD_WEAGOD_REPLY.getWeatimes(self)
	return self.weatimes
end

-- {是否可一键招财(1：可以 | 0：不可以)}
function ACK_WEAGOD_WEAGOD_REPLY.getQkgold(self)
	return self.qkgold
end

-- {当前已招财次数}
function ACK_WEAGOD_WEAGOD_REPLY.getGetweatimes(self)
	return self.getweatimes
end

-- {当前招一次可获得银元}
function ACK_WEAGOD_WEAGOD_REPLY.getGetgold(self)
	return self.getgold
end

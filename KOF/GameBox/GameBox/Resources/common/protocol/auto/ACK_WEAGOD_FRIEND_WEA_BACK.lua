
require "common/AcknowledgementMessage"

-- (手动) -- [32100]好友财神信息返回 -- 财神 

ACK_WEAGOD_FRIEND_WEA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_FRIEND_WEA_BACK
	self:init()
end)

function ACK_WEAGOD_FRIEND_WEA_BACK.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {好友Uid}
	self.wea_lv = reader:readInt8Unsigned() -- {财神等级}
	self.wea_exp = reader:readInt32Unsigned() -- {财神财气}
end

-- {好友Uid}
function ACK_WEAGOD_FRIEND_WEA_BACK.getUid(self)
	return self.uid
end

-- {财神等级}
function ACK_WEAGOD_FRIEND_WEA_BACK.getWeaLv(self)
	return self.wea_lv
end

-- {财神财气}
function ACK_WEAGOD_FRIEND_WEA_BACK.getWeaExp(self)
	return self.wea_exp
end

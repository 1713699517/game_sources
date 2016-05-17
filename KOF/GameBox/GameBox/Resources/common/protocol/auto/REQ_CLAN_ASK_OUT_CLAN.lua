
require "common/RequestMessage"

-- [33150]请求退出|解散帮派 -- 社团 

REQ_CLAN_ASK_OUT_CLAN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_OUT_CLAN
	self:init(1 ,{ 33160,700 })
end)

function REQ_CLAN_ASK_OUT_CLAN.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1 退出帮派| 0 解散帮派}
end

function REQ_CLAN_ASK_OUT_CLAN.setArguments(self,type)
	self.type = type  -- {1 退出帮派| 0 解散帮派}
end

-- {1 退出帮派| 0 解散帮派}
function REQ_CLAN_ASK_OUT_CLAN.setType(self, type)
	self.type = type
end
function REQ_CLAN_ASK_OUT_CLAN.getType(self)
	return self.type
end


require "common/RequestMessage"

-- [33110]请求修改帮派公告 -- 社团 

REQ_CLAN_ASK_RESET_CAST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_RESET_CAST
	self:init(1 ,{ 33120,700 })
end)

function REQ_CLAN_ASK_RESET_CAST.serialize(self, writer)
	writer:writeUTF(self.string)  -- {公告内容}
end

function REQ_CLAN_ASK_RESET_CAST.setArguments(self,string)
	self.string = string  -- {公告内容}
end

-- {公告内容}
function REQ_CLAN_ASK_RESET_CAST.setString(self, string)
	self.string = string
end
function REQ_CLAN_ASK_RESET_CAST.getString(self)
	return self.string
end


require "common/RequestMessage"

-- [33030]请求帮派列表 -- 社团 

REQ_CLAN_ASL_CLANLIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASL_CLANLIST
	self:init(1 ,{ 33034,33036,700 })
end)

function REQ_CLAN_ASL_CLANLIST.serialize(self, writer)
	writer:writeInt16Unsigned(self.page)  -- {第几页}
end

function REQ_CLAN_ASL_CLANLIST.setArguments(self,page)
	self.page = page  -- {第几页}
end

-- {第几页}
function REQ_CLAN_ASL_CLANLIST.setPage(self, page)
	self.page = page
end
function REQ_CLAN_ASL_CLANLIST.getPage(self)
	return self.page
end

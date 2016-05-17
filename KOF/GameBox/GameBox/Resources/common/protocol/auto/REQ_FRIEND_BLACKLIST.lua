
require "common/RequestMessage"

-- (手动) -- [4090]黑名单 -- 好友 

REQ_FRIEND_BLACKLIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_BLACKLIST
	self:init()
end)

function REQ_FRIEND_BLACKLIST.serialize(self, writer)
	writer:writeInt32Unsigned(self.fid)  -- {关系人id}
end

function REQ_FRIEND_BLACKLIST.setArguments(self,fid)
	self.fid = fid  -- {关系人id}
end

-- {关系人id}
function REQ_FRIEND_BLACKLIST.setFid(self, fid)
	self.fid = fid
end
function REQ_FRIEND_BLACKLIST.getFid(self)
	return self.fid
end

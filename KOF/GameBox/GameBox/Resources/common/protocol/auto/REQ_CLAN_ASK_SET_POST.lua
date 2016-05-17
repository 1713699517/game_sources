
require "common/RequestMessage"

-- [33135]请求设置成员职位 -- 社团 

REQ_CLAN_ASK_SET_POST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_SET_POST
	self:init(1 ,{ 33140,700 })
end)

function REQ_CLAN_ASK_SET_POST.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家uid}
	writer:writeInt8Unsigned(self.post)  -- {新职位类型 CONST_CLAN_POST_}
end

function REQ_CLAN_ASK_SET_POST.setArguments(self,uid,post)
	self.uid = uid  -- {玩家uid}
	self.post = post  -- {新职位类型 CONST_CLAN_POST_}
end

-- {玩家uid}
function REQ_CLAN_ASK_SET_POST.setUid(self, uid)
	self.uid = uid
end
function REQ_CLAN_ASK_SET_POST.getUid(self)
	return self.uid
end

-- {新职位类型 CONST_CLAN_POST_}
function REQ_CLAN_ASK_SET_POST.setPost(self, post)
	self.post = post
end
function REQ_CLAN_ASK_SET_POST.getPost(self)
	return self.post
end

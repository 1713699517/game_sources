
require "common/RequestMessage"

-- [14060]罢免官员 -- 阵营 

REQ_COUNTRY_POST_RECALL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_POST_RECALL
	self:init(0, nil)
end)

function REQ_COUNTRY_POST_RECALL.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家uid}
	writer:writeInt8Unsigned(self.post)  -- {职位类型(见常量)}
end

function REQ_COUNTRY_POST_RECALL.setArguments(self,uid,post)
	self.uid = uid  -- {玩家uid}
	self.post = post  -- {职位类型(见常量)}
end

-- {玩家uid}
function REQ_COUNTRY_POST_RECALL.setUid(self, uid)
	self.uid = uid
end
function REQ_COUNTRY_POST_RECALL.getUid(self)
	return self.uid
end

-- {职位类型(见常量)}
function REQ_COUNTRY_POST_RECALL.setPost(self, post)
	self.post = post
end
function REQ_COUNTRY_POST_RECALL.getPost(self)
	return self.post
end

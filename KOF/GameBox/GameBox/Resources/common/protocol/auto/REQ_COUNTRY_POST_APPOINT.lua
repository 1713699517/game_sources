
require "common/RequestMessage"

-- [14050]任命官员 -- 阵营 

REQ_COUNTRY_POST_APPOINT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_POST_APPOINT
	self:init(0, nil)
end)

function REQ_COUNTRY_POST_APPOINT.serialize(self, writer)
	writer:writeString(self.name)  -- {玩家名字}
	writer:writeInt8Unsigned(self.post)  -- {职位类型(见常量)}
end

function REQ_COUNTRY_POST_APPOINT.setArguments(self,name,post)
	self.name = name  -- {玩家名字}
	self.post = post  -- {职位类型(见常量)}
end

-- {玩家名字}
function REQ_COUNTRY_POST_APPOINT.setName(self, name)
	self.name = name
end
function REQ_COUNTRY_POST_APPOINT.getName(self)
	return self.name
end

-- {职位类型(见常量)}
function REQ_COUNTRY_POST_APPOINT.setPost(self, post)
	self.post = post
end
function REQ_COUNTRY_POST_APPOINT.getPost(self)
	return self.post
end

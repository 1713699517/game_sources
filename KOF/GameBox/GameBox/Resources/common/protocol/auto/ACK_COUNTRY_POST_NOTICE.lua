
require "common/AcknowledgementMessage"

-- [14080]阵营职位改变消息通知(阵营广播) -- 阵营 

ACK_COUNTRY_POST_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_POST_NOTICE
	self:init()
end)

function ACK_COUNTRY_POST_NOTICE.deserialize(self, reader)
	self.type = reader:readBoolean() -- {true : 任命 | false : 罢免(辞职)}
	self.post = reader:readInt8Unsigned() -- {职位类型(见常量)}
	self.uid = reader:readInt32Unsigned() -- {uid}
	self.name = reader:readString() -- {名字}
end

-- {true : 任命 | false : 罢免(辞职)}
function ACK_COUNTRY_POST_NOTICE.getType(self)
	return self.type
end

-- {职位类型(见常量)}
function ACK_COUNTRY_POST_NOTICE.getPost(self)
	return self.post
end

-- {uid}
function ACK_COUNTRY_POST_NOTICE.getUid(self)
	return self.uid
end

-- {名字}
function ACK_COUNTRY_POST_NOTICE.getName(self)
	return self.name
end

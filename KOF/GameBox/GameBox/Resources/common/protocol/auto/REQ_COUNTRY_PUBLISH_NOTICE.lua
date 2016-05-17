
require "common/RequestMessage"

-- [14040]发布阵营公告 -- 阵营 

REQ_COUNTRY_PUBLISH_NOTICE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_PUBLISH_NOTICE
	self:init(0, nil)
end)

function REQ_COUNTRY_PUBLISH_NOTICE.serialize(self, writer)
	writer:writeUTF(self.notice)  -- {阵营公告文字}
end

function REQ_COUNTRY_PUBLISH_NOTICE.setArguments(self,notice)
	self.notice = notice  -- {阵营公告文字}
end

-- {阵营公告文字}
function REQ_COUNTRY_PUBLISH_NOTICE.setNotice(self, notice)
	self.notice = notice
end
function REQ_COUNTRY_PUBLISH_NOTICE.getNotice(self)
	return self.notice
end

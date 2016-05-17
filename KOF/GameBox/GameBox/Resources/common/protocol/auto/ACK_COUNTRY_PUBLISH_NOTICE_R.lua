
require "common/AcknowledgementMessage"

-- [14045]发布阵营公告返回(阵营广播) -- 阵营 

ACK_COUNTRY_PUBLISH_NOTICE_R = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_PUBLISH_NOTICE_R
	self:init()
end)

function ACK_COUNTRY_PUBLISH_NOTICE_R.deserialize(self, reader)
	self.notice = reader:readUTF() -- {阵营公告文字}
end

-- {阵营公告文字}
function ACK_COUNTRY_PUBLISH_NOTICE_R.getNotice(self)
	return self.notice
end

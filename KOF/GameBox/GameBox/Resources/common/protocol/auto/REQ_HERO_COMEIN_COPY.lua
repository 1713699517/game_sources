
require "common/RequestMessage"

-- (手动) -- [39030]进入战役 -- 英雄副本 

REQ_HERO_COMEIN_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_COMEIN_COPY
	self:init()
end)

function REQ_HERO_COMEIN_COPY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_HERO_COMEIN_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_HERO_COMEIN_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_HERO_COMEIN_COPY.getCopyId(self)
	return self.copy_id
end

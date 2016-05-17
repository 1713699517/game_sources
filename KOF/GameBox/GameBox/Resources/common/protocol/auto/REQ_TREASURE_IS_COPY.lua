
require "common/RequestMessage"

-- [47310]请求副本时候开启 -- 珍宝阁系统 

REQ_TREASURE_IS_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_IS_COPY
	self:init(0, nil)
end)

function REQ_TREASURE_IS_COPY.serialize(self, writer)
	writer:writeInt32Unsigned(self.copy_id)  -- {副本id}
end

function REQ_TREASURE_IS_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本id}
end

-- {副本id}
function REQ_TREASURE_IS_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_TREASURE_IS_COPY.getCopyId(self)
	return self.copy_id
end

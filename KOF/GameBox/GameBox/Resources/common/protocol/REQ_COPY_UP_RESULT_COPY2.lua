
require "common/RequestMessage"

-- (手动) -- [7975]挂机-请求挂机结果 -- 副本 

REQ_COPY_UP_RESULT_COPY2 = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_RESULT_COPY2
	self:init()
end)

function REQ_COPY_UP_RESULT_COPY2.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
	writer:writeInt16Unsigned(self.copy_times)  -- {轮数或者次数}
end

function REQ_COPY_UP_RESULT_COPY2.setArguments(self,copy_id,copy_times)
	self.copy_id = copy_id  -- {副本ID}
	self.copy_times = copy_times  -- {轮数或者次数}
end

-- {副本ID}
function REQ_COPY_UP_RESULT_COPY2.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_UP_RESULT_COPY2.getCopyId(self)
	return self.copy_id
end

-- {轮数或者次数}
function REQ_COPY_UP_RESULT_COPY2.setCopyTimes(self, copy_times)
	self.copy_times = copy_times
end
function REQ_COPY_UP_RESULT_COPY2.getCopyTimes(self)
	return self.copy_times
end

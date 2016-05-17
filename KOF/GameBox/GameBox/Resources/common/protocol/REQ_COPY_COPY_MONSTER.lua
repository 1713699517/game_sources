
require "common/RequestMessage"

-- (手动) -- [7720]请求怪物数据 -- 副本 

REQ_COPY_COPY_MONSTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_COPY_MONSTER
	self:init()
end)

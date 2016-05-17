
require "common/RequestMessage"

-- (手动) -- [54807]请求格斗之王 -- 格斗之王 

REQ_WRESTLE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_REQUEST
	self:init()
end)

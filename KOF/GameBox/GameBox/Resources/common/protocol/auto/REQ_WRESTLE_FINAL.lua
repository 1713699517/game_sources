
require "common/RequestMessage"

-- (手动) -- [54860]请求决赛 -- 格斗之王 

REQ_WRESTLE_FINAL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_FINAL
	self:init()
end)

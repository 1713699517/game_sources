
require "common/RequestMessage"

-- (手动) -- [54830]请求开始战斗 -- 格斗之王 

REQ_WRESTLE_STARE_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_STARE_WAR
	self:init()
end)

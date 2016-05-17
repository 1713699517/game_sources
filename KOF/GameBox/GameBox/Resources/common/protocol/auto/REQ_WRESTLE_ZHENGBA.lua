
require "common/RequestMessage"

-- [54910]王者争霸入口 -- 格斗之王 

REQ_WRESTLE_ZHENGBA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_ZHENGBA
	self:init(0, nil)
end)

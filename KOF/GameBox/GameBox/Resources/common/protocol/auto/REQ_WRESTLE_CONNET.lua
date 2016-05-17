
require "common/RequestMessage"

-- [54892]断线重连 -- 格斗之王 

REQ_WRESTLE_CONNET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_CONNET
	self:init(0, nil)
end)

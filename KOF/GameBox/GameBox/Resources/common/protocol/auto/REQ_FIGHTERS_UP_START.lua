
require "common/RequestMessage"

-- [55860]开始挂机 -- 拳皇生涯 

REQ_FIGHTERS_UP_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_UP_START
	self:init(1 ,{ 55870,55880,700 })
end)

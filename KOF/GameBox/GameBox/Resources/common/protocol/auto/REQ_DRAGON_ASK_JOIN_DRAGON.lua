
require "common/RequestMessage"

-- [34010]请求寻宝界面 -- 活动-龙宫寻宝 

REQ_DRAGON_ASK_JOIN_DRAGON = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DRAGON_ASK_JOIN_DRAGON
	self:init(0, nil)
end)

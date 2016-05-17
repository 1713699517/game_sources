
require "common/RequestMessage"

-- [2640]一键附魔 -- 物品/打造/强化 

REQ_MAKE_KEY_ENCHANT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_KEY_ENCHANT
	self:init(0, nil)
end)

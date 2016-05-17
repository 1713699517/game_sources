
require "common/RequestMessage"

-- [1115]请求玩家排名更新 -- 角色 

REQ_ROLE_RANK_UPDATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_RANK_UPDATE
	self:init(0, nil)
end)

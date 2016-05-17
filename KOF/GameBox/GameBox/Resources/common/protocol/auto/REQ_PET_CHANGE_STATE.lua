
require "common/RequestMessage"

-- (手动) -- [22830]改变宠物状态 -- 宠物 

REQ_PET_CHANGE_STATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_CHANGE_STATE
	self:init()
end)

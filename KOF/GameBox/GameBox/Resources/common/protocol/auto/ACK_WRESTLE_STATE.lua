
require "common/AcknowledgementMessage"

-- [54812]活动状态 -- 格斗之王 

ACK_WRESTLE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_STATE
	self:init()
end)

function ACK_WRESTLE_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {0:预赛进行中|2:决赛进行中|3：决赛结束|4：争霸赛进行中|5：争霸赛已经结束}
end

-- {0:预赛进行中|2:决赛进行中|3：决赛结束|4：争霸赛进行中|5：争霸赛已经结束}
function ACK_WRESTLE_STATE.getState(self)
	return self.state
end

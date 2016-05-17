
require "common/RequestMessage"

-- [10720]设置称号状态 -- 称号 

REQ_TITLE_SET_STATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TITLE_SET_STATE
	self:init(1 ,{ 10730，700 })
end)

function REQ_TITLE_SET_STATE.serialize(self, writer)
	writer:writeInt8Unsigned(self.state)  -- {1:启用中 | 0:未启用}
	writer:writeInt16Unsigned(self.tid)  -- {称号id}
end

function REQ_TITLE_SET_STATE.setArguments(self,state,tid)
	self.state = state  -- {1:启用中 | 0:未启用}
	self.tid = tid  -- {称号id}
end

-- {1:启用中 | 0:未启用}
function REQ_TITLE_SET_STATE.setState(self, state)
	self.state = state
end
function REQ_TITLE_SET_STATE.getState(self)
	return self.state
end

-- {称号id}
function REQ_TITLE_SET_STATE.setTid(self, tid)
	self.tid = tid
end
function REQ_TITLE_SET_STATE.getTid(self)
	return self.tid
end

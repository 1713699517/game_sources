
require "common/AcknowledgementMessage"

-- [22103]请求声望面板成功 -- 声望 

ACK_RENOWN_REQUEST_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_RENOWN_REQUEST_OK
	self:init()
end)

function ACK_RENOWN_REQUEST_OK.deserialize(self, reader)
	self.renown_lv = reader:readInt8Unsigned() -- {当前声望等级}
	self.renown_exp = reader:readInt32Unsigned() -- {当前声望值}
	self.states = reader:readInt8Unsigned() -- {播放升级特效 是:?CONST_TRUE|否:?CONST_FALSE}
end

-- {当前声望等级}
function ACK_RENOWN_REQUEST_OK.getRenownLv(self)
	return self.renown_lv
end

-- {当前声望值}
function ACK_RENOWN_REQUEST_OK.getRenownExp(self)
	return self.renown_exp
end

-- {播放升级特效 是:?CONST_TRUE|否:?CONST_FALSE}
function ACK_RENOWN_REQUEST_OK.getStates(self)
	return self.states
end

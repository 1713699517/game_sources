
require "common/AcknowledgementMessage"

-- (手动) -- [4040]好友状态更新 -- 好友 

ACK_FRIEND_UPDATE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_UPDATE_STATE
	self:init()
end)

function ACK_FRIEND_UPDATE_STATE.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器Sid}
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.state = reader:readInt8Unsigned() -- {更新状态}
end

-- {服务器Sid}
function ACK_FRIEND_UPDATE_STATE.getSid(self)
	return self.sid
end

-- {玩家Uid}
function ACK_FRIEND_UPDATE_STATE.getUid(self)
	return self.uid
end

-- {更新状态}
function ACK_FRIEND_UPDATE_STATE.getState(self)
	return self.state
end

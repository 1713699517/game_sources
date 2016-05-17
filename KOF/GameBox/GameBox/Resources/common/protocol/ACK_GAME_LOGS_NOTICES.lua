
require "common/AcknowledgementMessage"
require "common/protocol/auto/ACK_GAME_LOGS_MESS"

-- [22760]获得|失去通知 -- 日志 

ACK_GAME_LOGS_NOTICES = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GAME_LOGS_NOTICES
	self:init()
end)

function ACK_GAME_LOGS_NOTICES.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型：CONST_LOGS_TYPE_XX 1 - 4}
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.mess = reader:readXXXGroup() -- {信息组协议块 [22770]}
    self.mess = {}
    for i=1,self.count do
        local mess = ACK_GAME_LOGS_MESS()
        mess : deserialize( reader )
        table.insert(self.mess , mess )
    end
end

-- {类型：CONST_LOGS_TYPE_XX 1 - 4}
function ACK_GAME_LOGS_NOTICES.getType(self)
	return self.type
end

-- {数量}
function ACK_GAME_LOGS_NOTICES.getCount(self)
	return self.count
end

-- {信息组协议块 [22770]}
function ACK_GAME_LOGS_NOTICES.getMess(self)
	return self.mess
end

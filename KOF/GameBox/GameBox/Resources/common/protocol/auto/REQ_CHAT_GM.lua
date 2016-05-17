
require "common/RequestMessage"

-- [9600]GM命令 -- 聊天 

REQ_CHAT_GM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_GM
	self:init(0, nil)
end)

function REQ_CHAT_GM.serialize(self, writer)
	writer:writeString(self.command)  -- {命令}
end

function REQ_CHAT_GM.setArguments(self,command)
	self.command = command  -- {命令}
end

-- {命令}
function REQ_CHAT_GM.setCommand(self, command)
	self.command = command
end
function REQ_CHAT_GM.getCommand(self)
	return self.command
end


require "common/AcknowledgementMessage"
require "common/protocol/auto/ACK_GAME_LOGS_STR_XXX"
require "common/protocol/auto/ACK_GAME_LOGS_INT_XXX"

-- [22780]事件通知 -- 日志 

ACK_GAME_LOGS_EVENT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GAME_LOGS_EVENT
	self:init()
end)

function ACK_GAME_LOGS_EVENT.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {事件ID}
    print("LOG ID: ",self.id)
	self.count_str = reader:readInt16Unsigned() -- {字符串数量}
	self.str_module = {} --reader:readXXXGroup() -- {字符串信息块[22781]}
	for i=1,self.count_str do
		local tmp = ACK_GAME_LOGS_STR_XXX()
		tmp : deserialize( reader )
		table.insert( self.str_module, tmp )
	end
	self.count_int = reader:readInt16Unsigned() -- {数字数量}
	self.int_module = {}--reader:readXXXGroup() -- {数字信息块[22782]}
	for i=1,self.count_int do
		local tmp = ACK_GAME_LOGS_INT_XXX()
		tmp : deserialize( reader )
		table.insert( self.int_module, tmp )
	end
end

-- {事件ID}
function ACK_GAME_LOGS_EVENT.getId(self)
	return self.id
end

-- {字符串数量}
function ACK_GAME_LOGS_EVENT.getCountStr(self)
	return self.count_str
end

-- {字符串信息块[22781]}
function ACK_GAME_LOGS_EVENT.getStrModule(self)
	return self.str_module
end

-- {数字数量}
function ACK_GAME_LOGS_EVENT.getCountInt(self)
	return self.count_int
end

-- {数字信息块[22782]}
function ACK_GAME_LOGS_EVENT.getIntModule(self)
	return self.int_module
end

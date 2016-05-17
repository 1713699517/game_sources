
require "common/RequestMessage"

-- (手动) -- [6022]战斗结束--复活选项 -- 战斗 

REQ_WAR_DIE_OPTION = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_DIE_OPTION
	self:init()
end)

function REQ_WAR_DIE_OPTION.serialize(self, writer)
	writer:writeInt8Unsigned(self.option)  -- {复活选项（见战斗常量CONST_WAR_OVER_*）}
end

function REQ_WAR_DIE_OPTION.setArguments(self,option)
	self.option = option  -- {复活选项（见战斗常量CONST_WAR_OVER_*）}
end

-- {复活选项（见战斗常量CONST_WAR_OVER_*）}
function REQ_WAR_DIE_OPTION.setOption(self, option)
	self.option = option
end
function REQ_WAR_DIE_OPTION.getOption(self)
	return self.option
end

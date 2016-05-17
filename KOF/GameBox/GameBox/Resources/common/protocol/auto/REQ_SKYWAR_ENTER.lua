
require "common/RequestMessage"

-- [40520]请求进入(或退出)天空之战场景 -- 天宫之战 

REQ_SKYWAR_ENTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_ENTER
	self:init(0, nil)
end)

function REQ_SKYWAR_ENTER.serialize(self, writer)
	writer:writeBoolean(self.choose)  -- {true:进入|false:退出}
end

function REQ_SKYWAR_ENTER.setArguments(self,choose)
	self.choose = choose  -- {true:进入|false:退出}
end

-- {true:进入|false:退出}
function REQ_SKYWAR_ENTER.setChoose(self, choose)
	self.choose = choose
end
function REQ_SKYWAR_ENTER.getChoose(self)
	return self.choose
end

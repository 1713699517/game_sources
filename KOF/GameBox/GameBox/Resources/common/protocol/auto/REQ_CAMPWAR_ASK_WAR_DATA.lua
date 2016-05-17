
require "common/RequestMessage"

-- [45800]请求设置战报数据类型 -- 活动-阵营战 

REQ_CAMPWAR_ASK_WAR_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_ASK_WAR_DATA
	self:init(0, nil)
end)

function REQ_CAMPWAR_ASK_WAR_DATA.serialize(self, writer)
	writer:writeInt8Unsigned(self.wtype)  -- {战报类型}
end

function REQ_CAMPWAR_ASK_WAR_DATA.setArguments(self,wtype)
	self.wtype = wtype  -- {战报类型}
end

-- {战报类型}
function REQ_CAMPWAR_ASK_WAR_DATA.setWtype(self, wtype)
	self.wtype = wtype
end
function REQ_CAMPWAR_ASK_WAR_DATA.getWtype(self)
	return self.wtype
end

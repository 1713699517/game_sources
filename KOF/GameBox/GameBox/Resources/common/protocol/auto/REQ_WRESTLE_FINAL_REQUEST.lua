
require "common/RequestMessage"

-- [54850]决赛入口 -- 格斗之王 

REQ_WRESTLE_FINAL_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_FINAL_REQUEST
	self:init(0, nil)
end)

function REQ_WRESTLE_FINAL_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:上半区|1:下半区}
end

function REQ_WRESTLE_FINAL_REQUEST.setArguments(self,type)
	self.type = type  -- {0:上半区|1:下半区}
end

-- {0:上半区|1:下半区}
function REQ_WRESTLE_FINAL_REQUEST.setType(self, type)
	self.type = type
end
function REQ_WRESTLE_FINAL_REQUEST.getType(self)
	return self.type
end

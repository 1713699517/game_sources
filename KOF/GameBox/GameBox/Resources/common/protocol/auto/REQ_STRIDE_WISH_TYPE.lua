
require "common/RequestMessage"

-- [43580]玩家许愿类型 -- 跨服战 

REQ_STRIDE_WISH_TYPE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_WISH_TYPE
	self:init(0, nil)
end)

function REQ_STRIDE_WISH_TYPE.serialize(self, writer)
	writer:writeInt8Unsigned(self.wish_type)  -- {1:千纸鹤2:孔明灯3:流星雨}
end

function REQ_STRIDE_WISH_TYPE.setArguments(self,wish_type)
	self.wish_type = wish_type  -- {1:千纸鹤2:孔明灯3:流星雨}
end

-- {1:千纸鹤2:孔明灯3:流星雨}
function REQ_STRIDE_WISH_TYPE.setWishType(self, wish_type)
	self.wish_type = wish_type
end
function REQ_STRIDE_WISH_TYPE.getWishType(self)
	return self.wish_type
end

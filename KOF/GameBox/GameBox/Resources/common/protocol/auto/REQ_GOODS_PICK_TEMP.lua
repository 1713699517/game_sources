
require "common/RequestMessage"

-- [2250]提取临时背包物品 -- 物品/背包 

REQ_GOODS_PICK_TEMP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_PICK_TEMP
	self:init(0, nil)
end)

function REQ_GOODS_PICK_TEMP.serialize(self, writer)
	writer:writeInt16Unsigned(self.idx)  -- {0:一键提取|物品idx}
end

function REQ_GOODS_PICK_TEMP.setArguments(self,idx)
	self.idx = idx  -- {0:一键提取|物品idx}
end

-- {0:一键提取|物品idx}
function REQ_GOODS_PICK_TEMP.setIdx(self, idx)
	self.idx = idx
end
function REQ_GOODS_PICK_TEMP.getIdx(self)
	return self.idx
end

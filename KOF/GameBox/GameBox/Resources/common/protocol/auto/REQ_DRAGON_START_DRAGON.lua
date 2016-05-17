
require "common/RequestMessage"

-- [34030]开始寻宝 -- 活动-龙宫寻宝 

REQ_DRAGON_START_DRAGON = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DRAGON_START_DRAGON
	self:init(0, nil)
end)

function REQ_DRAGON_START_DRAGON.serialize(self, writer)
	writer:writeInt32(self.num)  -- {寻宝次数}
end

function REQ_DRAGON_START_DRAGON.setArguments(self,num)
	self.num = num  -- {寻宝次数}
end

-- {寻宝次数}
function REQ_DRAGON_START_DRAGON.setNum(self, num)
	self.num = num
end
function REQ_DRAGON_START_DRAGON.getNum(self)
	return self.num
end
